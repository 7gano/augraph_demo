//
//  NNSequenceView.h
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import <UIKit/UIKit.h>
#import "NNStepsView.h"

@protocol NNSequenceViewDelegate;

@interface NNSequenceView : UIView
<NNStepsViewDelegate>
{
    NSMutableArray *_tracks;
}

@property(nonatomic, weak)id<NNSequenceViewDelegate> delegate;

- (void)updateStatus:(NSArray*)status;

@end

@protocol NNSequenceViewDelegate <NSObject>
@optional

- (void)sequenceView:(NNSequenceView*)sequenceView didTapTrackAtIndex:(NSUInteger)index step:(NSUInteger)step;

@end
