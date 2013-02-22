//
//  NNStepsView.m
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import "NNStepsView.h"
#import "NNStepButton.h"

static const NSUInteger numberOfSteps = 16;

@implementation NNStepsView

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) {
        return nil;
    }
    
    _buttons = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < numberOfSteps; i++) {
        UIButton *button = [[NNStepButton alloc] init];
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:(UIControlStateNormal)];
        [_buttons addObject:button];
        [button addTarget:self
                   action:@selector(_buttonAction:)
         forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:button];
    }
    
    return self;
}

//----------------------------------------------------------------------------//
#pragma mark -- View --
//----------------------------------------------------------------------------//

- (void)setStatus:(NSString*)trackStatusString
{
    for (NSUInteger j = 0; j < [trackStatusString length]; j++) {
        if (j < 16) {
            NSString *s = [trackStatusString substringWithRange:NSMakeRange(j, 1)];
            UIButton *button = [_buttons objectAtIndex:j];
            button.selected = [s isEqualToString:@"1"];
        }
    }
}

//----------------------------------------------------------------------------//
#pragma mark -- View --
//----------------------------------------------------------------------------//

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = CGRectZero;
    rect.size.width = CGRectGetWidth(self.bounds) / numberOfSteps;
    rect.size.height = CGRectGetHeight(self.bounds);
    
    for (UIButton *button in _buttons) {
        button.frame = rect;
        rect.origin.x += CGRectGetWidth(rect);
    }
}

//----------------------------------------------------------------------------//
#pragma mark -- Action --
//----------------------------------------------------------------------------//

- (void)_buttonAction:(UIButton*)button
{
    NSUInteger index = [_buttons indexOfObject:button];
    if ([self.delegate respondsToSelector:@selector(stepsView:didTapAtIndex:)]) {
        [self.delegate stepsView:self didTapAtIndex:index];
    }
}

@end
