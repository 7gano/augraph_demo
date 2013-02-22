//
//  NNViewController.m
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import "NNViewController.h"
#import "NNSequencer.h"
#import "NNSampler.h"

@interface NNViewController ()

@end


@implementation NNViewController

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)init
{
    self = [super init];
    if (nil == self) {
        return nil;
    }
    
    _sampler = [[NNSampler alloc] init];
    NSURL *presetURL;
    presetURL = [[NSBundle mainBundle] URLForResource:@"TR-909_Drums"
                                        withExtension:@"SF2"];
    [_sampler loadFromDLSOrSoundFont:presetURL withPatch:1];
    
    _sequencer = [[NNSequencer alloc] init];
    _sequencer.delegate = self;
    
    return self;
}

//----------------------------------------------------------------------------//
#pragma mark -- View --
//----------------------------------------------------------------------------//

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _sequeceView = [[NNSequenceView alloc] initWithFrame:self.view.bounds];
    _sequeceView.delegate = self;
    _sequeceView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_sequeceView];
    [self _updateSequenceView];
    
    [_sequencer play];
}

- (void)_updateSequenceView
{
    NSArray *tracksStatusStrings = [_sequencer tracksStatusStrings];
    [_sequeceView updateStatus:tracksStatusStrings];
}

//----------------------------------------------------------------------------//
#pragma mark -- NNSequencerDelegate --
//----------------------------------------------------------------------------//

- (void)sequencer:(NNSequencer*)sequencer didTriggerStep:(NSUInteger)step
{
    for (NSUInteger i = 0; i <sequencer.numberOfTracks; i++) {
        BOOL state = [sequencer stateAtTrack:i step:step];
        if (state) {
            NSUInteger noteNumber = 0;
            switch (i) {
                case 0: //track 0
                {
                    noteNumber = 36; //Kick C2
                }
                    break;
                    
                case 1: //track 1
                {
                    noteNumber = 39; //Snare
                }
                    break;
                    
                case 2: //track 2
                {
                    noteNumber = 37; //clap
                }
                    break;
                    
                case 3: //track 3
                {
                    noteNumber = 42; //hat
                }
                    break;
                    
                default:
                    break;
            }
            [_sampler triggerNote:noteNumber];
        }
    }
}

//----------------------------------------------------------------------------//
#pragma mark -- NNSequenceViewDelegate --
//----------------------------------------------------------------------------//

- (void)sequenceView:(NNSequenceView*)sequenceView didTapTrackAtIndex:(NSUInteger)index step:(NSUInteger)step
{
    BOOL state = [_sequencer stateAtTrack:index step:step];
    [_sequencer setState:!state atTrack:index step:step];    
    [self _updateSequenceView];
}

@end
