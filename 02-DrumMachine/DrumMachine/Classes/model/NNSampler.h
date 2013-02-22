//
//  NNSampler.h
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface NNSampler : NSObject
{
    AUGraph     _AUGraph;
    AudioUnit   _samplerUnit;
}

-(OSStatus)loadFromDLSOrSoundFont:(NSURL *)bankURL withPatch:(int)presetNumber;
- (void)triggerNote:(NSUInteger)note;

@end
