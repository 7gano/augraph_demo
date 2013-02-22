//
//  NNSequencer.m
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import "NNSequencer.h"

@implementation NNSequencer

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    self = [super init];
    if (nil == self) {
        return nil;
    }
    
    _BPM = 120;
    _currentStep = 0;
    
    self.tracksStatusStrings = @[
    @"1000100011000010",
    @"0001001000010010",
    @"0011001100110011",
    @"0010001000100010"
    ];
    
    return self;
}

//----------------------------------------------------------------------------//
#pragma mark -- Property --
//----------------------------------------------------------------------------//

- (NSUInteger)numberOfTracks
{
    return 4;
}

- (NSUInteger)numberOfSteps
{
    return 16;
}


- (void)setBPM:(NSUInteger)BPM
{
    _BPM = BPM;
    
    if (self.isPlaying) {
        [self stop];
        [self play];
    }
}

- (BOOL)isPlaying
{
    return _timer != nil;
}

- (BOOL)stateAtTrack:(NSUInteger)trackIndex step:(NSUInteger)step
{
    if (trackIndex < self.numberOfTracks && step < self.numberOfSteps) {
        return sequence[trackIndex][step];
    }
    return NO;
}

- (void)setState:(BOOL)state atTrack:(NSUInteger)trackIndex step:(NSUInteger)step
{
    if (trackIndex < self.numberOfTracks && step < self.numberOfSteps) {
        sequence[trackIndex][step] = state;
    }
}

- (NSArray*)tracksStatusStrings
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.numberOfTracks; i++) {
        NSMutableString *string = [NSMutableString string];
        for (NSUInteger j = 0; j < self.numberOfSteps; j++) {
            NSString *step = sequence[i][j] ? @"1" : @"0";
            [string appendString:step];
        }
        [result addObject:string];
    }
    LOG(@"result = %@", result);
    return result;
}

- (void)setTracksStatusStrings:(NSArray*)statusStrings
{
    for (NSUInteger i = 0; i < self.numberOfTracks; i++) {
        NSString *trackStatusString = [statusStrings objectAtIndex:i];
        for (NSUInteger j = 0; j < [trackStatusString length]; j++) {
            if (j < self.numberOfSteps) {
                NSString *s = [trackStatusString substringWithRange:NSMakeRange(j, 1)];
                sequence[i][j] = [s isEqualToString:@"1"];
            }
        }
    }
}

//----------------------------------------------------------------------------//
#pragma mark -- Action --
//----------------------------------------------------------------------------//


- (void)play
{
    [_timer invalidate], _timer = nil;
    
    // Calc BPM
    CGFloat sixteenthNoteDuration = (60.0 / _BPM) * 0.25;
    if (sixteenthNoteDuration < 0.075) { //limit BPM 200
        sixteenthNoteDuration = 0.075;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:sixteenthNoteDuration
                                              target:self
                                            selector:@selector(_timerFired:)
                                            userInfo:nil
                                             repeats:YES];
    [self _timerFired:_timer];
}

- (void)stop
{
    [_timer invalidate], _timer = nil;
}

- (void)_timerFired:(NSTimer*)timer
{
    if ([self.delegate respondsToSelector:@selector(sequencer:didTriggerStep:)]) {
        [self.delegate sequencer:self didTriggerStep:_currentStep];
    }
    _currentStep++;
    if (_currentStep == self.numberOfSteps) {
        _currentStep = 0;
    }
}

@end
