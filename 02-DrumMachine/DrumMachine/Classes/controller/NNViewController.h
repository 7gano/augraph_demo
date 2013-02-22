//
//  NNViewController.h
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import <UIKit/UIKit.h>
#import "NNSequencer.h"
#import "NNSequenceView.h"

@class NNSampler;
@class NNSequenceView;

@interface NNViewController : UIViewController
<NNSequencerDelegate,
NNSequenceViewDelegate
>
{
    NNSampler       *_sampler;
    NNSequencer     *_sequencer;
    NNSequenceView  *_sequeceView;
}
@end
