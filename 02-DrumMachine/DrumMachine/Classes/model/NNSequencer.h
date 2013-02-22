//
//  NNSequencer.h
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import <Foundation/Foundation.h>

@protocol NNSequencerDelegate;

@interface NNSequencer : NSObject
{
    BOOL    sequence[4][16];
    NSTimer *_timer;
}

@property(nonatomic, weak)     id<NNSequencerDelegate> delegate;

@property(nonatomic, readonly) NSUInteger numberOfTracks;
@property(nonatomic, readonly) NSUInteger numberOfSteps;

@property(nonatomic)           NSUInteger BPM; //default 120
@property(nonatomic)           NSUInteger currentStep; //0-15
@property(nonatomic, readonly) BOOL       isPlaying;
@property(nonatomic)           NSArray    *tracksStatusStrings;

- (BOOL)stateAtTrack:(NSUInteger)trackIndex step:(NSUInteger)step;
- (void)setState:(BOOL)state atTrack:(NSUInteger)trackIndex step:(NSUInteger)step;

- (void)play;
- (void)stop;

@end


@protocol NNSequencerDelegate <NSObject>
@optional
- (void)sequencer:(NNSequencer*)sequencer didTriggerStep:(NSUInteger)step;
@end
