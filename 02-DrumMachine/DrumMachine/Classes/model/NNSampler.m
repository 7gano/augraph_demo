//
//  NNSampler.m
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import "NNSampler.h"
#import <AssertMacros.h>

@implementation NNSampler

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    self = [super init];
    if (nil == self) {
        return nil;
    }
    
    [self _prepareAUGraph];
    
    return self;
}

- (void)dealloc
{
    AUGraphUninitialize(_AUGraph);
    AUGraphClose(_AUGraph);
    DisposeAUGraph(_AUGraph);
}

//----------------------------------------------------------------------------//
#pragma mark -- AUGraph --
//----------------------------------------------------------------------------//

- (void)_prepareAUGraph
{
    OSStatus err;
    
    AUNode      samplerNode;
    AUNode      remoteOutputNode;
    
    err = NewAUGraph(&_AUGraph);
    err = AUGraphOpen(_AUGraph);
    
    AudioComponentDescription cd;
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType = kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = cd.componentFlagsMask = 0;
    
    err = AUGraphAddNode(_AUGraph, &cd, &remoteOutputNode);
    if (err) {
        LOG(@"err = %ld", err);
    }
    cd.componentType = kAudioUnitType_MusicDevice;
    cd.componentSubType = kAudioUnitSubType_Sampler;
    err = AUGraphAddNode(_AUGraph, &cd, &samplerNode);
    if (err) {
        LOG(@"err = %ld", err);
    }
    err = AUGraphConnectNodeInput(_AUGraph, samplerNode, 0, remoteOutputNode, 0);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    err = AUGraphInitialize(_AUGraph);
    if (err) {
        LOG(@"err = %ld", err);
    }
    err = AUGraphStart(_AUGraph);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    err = AUGraphNodeInfo(_AUGraph,
                          samplerNode,
                          NULL,
                          &_samplerUnit);
    if (err) {
        LOG(@"err = %ld", err);
    }
}

- (void)triggerNote:(NSUInteger)note
{
    //Note On
    [self noteOn:@(note) velocity:@127];
    //Note Off
    [self noteOn:@(note) velocity:@0];
}

- (void)noteOn:(NSNumber*)noteNumber velocity:(NSNumber*)velocityNumber
{
    NSUInteger note = [noteNumber unsignedIntegerValue];
    NSUInteger velocity = [noteNumber unsignedIntegerValue];
    
    MusicDeviceMIDIEvent(_samplerUnit,
                         0x90,
                         note,
                         velocity,
                         0);
}

//----------------------------------------------------------------------------//
#pragma mark -- Action --
//----------------------------------------------------------------------------//

-(OSStatus)loadFromDLSOrSoundFont:(NSURL *)bankURL withPatch:(int)presetNumber
{
    OSStatus result = noErr;
    // fill out a bank preset data structure
    AUSamplerBankPresetData bpdata;
    bpdata.bankURL  = (__bridge CFURLRef) bankURL;
    bpdata.bankMSB  = kAUSampler_DefaultMelodicBankMSB;
    bpdata.bankLSB  = kAUSampler_DefaultBankLSB;
    bpdata.presetID = (UInt8) presetNumber;
    
    // set the kAUSamplerProperty_LoadPresetFromBank property
    result = AudioUnitSetProperty(_samplerUnit,
                                  kAUSamplerProperty_LoadPresetFromBank,
                                  kAudioUnitScope_Global,
                                  0,
                                  &bpdata,
                                  sizeof(bpdata));
    // check for errors
    NSCAssert (result == noErr,
               @"Unable to set the preset property on the Sampler. Error code:%d '%.4s'",
               (int) result,
               (const char *)&result);
    return result;
}

@end
