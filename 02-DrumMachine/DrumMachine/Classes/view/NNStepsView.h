//
//  NNStepsView.h
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import <UIKit/UIKit.h>

@protocol NNStepsViewDelegate;

@interface NNStepsView : UIView
{
    NSMutableArray *_buttons;
}

@property(nonatomic, weak)id<NNStepsViewDelegate> delegate;

- (void)setStatus:(NSString*)status;

@end



@protocol NNStepsViewDelegate <NSObject>

- (void)stepsView:(NNStepsView*)stepsView didTapAtIndex:(NSUInteger)index;

@end