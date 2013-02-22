//
//  NNViewController.m
//  Reverb
//
//  Created by 7gano on 02/22/13
//  Copyright (c) 2012 7gano. All rights reserved.
//

#import "NNViewController.h"

@interface NNViewController ()

@end

@implementation NNViewController

- (void)play
{
    OSStatus err;
    
    AudioUnit remoteIOUnit;
    AudioUnit audioPlayerUnit;
    AudioUnit delayUnit;
    AUNode audioPlayerNode;
    AUNode remoteOutputNode;
    AUNode delayNode;
    
    err = NewAUGraph(&_AUGraph);
    err = AUGraphOpen(_AUGraph);
	
	AudioComponentDescription cd;
	cd.componentType = kAudioUnitType_Output;
	cd.componentSubType = kAudioUnitSubType_RemoteIO;
	cd.componentManufacturer = kAudioUnitManufacturer_Apple;
	cd.componentFlags = cd.componentFlagsMask = 0;
	
    //Node
	err = AUGraphAddNode(_AUGraph, &cd, &remoteOutputNode);
    if (err) {
        LOG(@"err = %ld", err);
    }
    //Get Audio Unit
    err = AUGraphNodeInfo(_AUGraph,
                          remoteOutputNode,
                          NULL,
                          &remoteIOUnit);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    //Create AudioPlayer
	cd.componentType = kAudioUnitType_Generator;
	cd.componentSubType = kAudioUnitSubType_AudioFilePlayer;
	err = AUGraphAddNode(_AUGraph, &cd, &audioPlayerNode);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    //Create Delay
	cd.componentType = kAudioUnitType_Effect;
	cd.componentSubType = kAudioUnitSubType_Delay;
	err = AUGraphAddNode(_AUGraph, &cd, &delayNode);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    AUGraphNodeInfo(_AUGraph,
                    delayNode,
                    NULL,
                    &delayUnit);
    //Get Audio Unit
    err = AUGraphNodeInfo(_AUGraph,
                          delayNode,
                          NULL,
                          &delayUnit);
    if (err) {
        LOG(@"err = %ld", err);
    }
    err = AUGraphConnectNodeInput(_AUGraph, audioPlayerNode, 0, delayNode, 0);
    if (err) {
        LOG(@"err = %ld", err);
    }
    err = AUGraphConnectNodeInput(_AUGraph, delayNode, 0, remoteOutputNode, 0);
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
                          audioPlayerNode,
                          NULL,
                          &audioPlayerUnit);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    AudioFileID audioFileID;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loop" withExtension:@"wav"];
    err = AudioFileOpenURL((__bridge CFURLRef)url,
                           kAudioFileReadPermission,
                           kAudioFileWAVEType, //MP3
                           &audioFileID);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    AudioFileID audioFileIDs[1];
    audioFileIDs[0] = audioFileID;
    UInt32 size = sizeof(AudioFileID);
    err = AudioUnitSetProperty(audioPlayerUnit,
                               kAudioUnitProperty_ScheduledFileIDs,
                               kAudioUnitScope_Global,
                               0,
                               audioFileIDs,
                               size);
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    ScheduledAudioFileRegion playRegion = {};
    playRegion.mTimeStamp.mFlags = kAudioTimeStampSampleTimeValid;
    playRegion.mAudioFile = audioFileID;
    playRegion.mLoopCount = -1;
    playRegion.mFramesToPlay = -1;
    playRegion.mCompletionProc = NULL;
    playRegion.mCompletionProcUserData = NULL;
    playRegion.mTimeStamp.mSampleTime = 0;
    playRegion.mStartFrame = 0;
    
    err = AudioUnitSetProperty(audioPlayerUnit,
                               kAudioUnitProperty_ScheduledFileRegion,
                               kAudioUnitScope_Global,
                               0,
                               &playRegion,
                               sizeof(playRegion));
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    // preload
    UInt32 primeFrames = 0;	// default
    err = AudioUnitSetProperty(audioPlayerUnit,
                               kAudioUnitProperty_ScheduledFilePrime,
                               kAudioUnitScope_Global,
                               0,
                               &primeFrames,
                               sizeof(primeFrames));
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    AudioTimeStamp startTime;
    startTime.mFlags = kAudioTimeStampSampleTimeValid;
    startTime.mSampleTime = -1;
    err = AudioUnitSetProperty(audioPlayerUnit,
                               kAudioUnitProperty_ScheduleStartTimeStamp,
                               kAudioUnitScope_Global,
                               0,
                               &startTime,
                               sizeof(startTime));
    if (err) {
        LOG(@"err = %ld", err);
    }
    
    //Preset
    NSURL *presetURL = [[NSBundle mainBundle] URLForResource:@"DelayTest"
                                               withExtension:@"aupreset"];
    CFDataRef propertyResourceData = 0;
    Boolean status;
    SInt32 errorCode = 0;
    
    status = CFURLCreateDataAndPropertiesFromResource (kCFAllocatorDefault,
                                                       (__bridge CFURLRef) presetURL,
                                                       &propertyResourceData,
                                                       NULL,
                                                       NULL,
                                                       &errorCode
                                                       );
    
    NSAssert (status == YES && propertyResourceData != 0,
              @"Unable to create data and properties from a preset. Error code: %d '%.4s'",
              (int) errorCode, (const char *)&errorCode);
    
    CFPropertyListRef presetPropertyList = 0;
    CFPropertyListFormat dataFormat = 0;
    CFErrorRef errorRef = 0;
    presetPropertyList = CFPropertyListCreateWithData(kCFAllocatorDefault,
                                                      propertyResourceData,
                                                      kCFPropertyListImmutable,
                                                      &dataFormat,
                                                      &errorRef
                                                      );
    
    if (presetPropertyList) {
        err = AudioUnitSetProperty(delayUnit,
                                   kAudioUnitProperty_ClassInfo,
                                   kAudioUnitScope_Global,
                                   0,
                                   &presetPropertyList,
                                   sizeof(CFPropertyListRef)
                                   );
        LOG(@"err = %ld", err);
        CFRelease(presetPropertyList);
    }
    if (errorRef){
        CFRelease(errorRef);
    }
    CFRelease (propertyResourceData);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self play];
}
@end
