//
//  NNStepButton.m
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import "NNStepButton.h"

@implementation NNStepButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor blackColor];

    [self setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self setTitleColor:[UIColor blackColor] forState:(UIControlStateSelected)];
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    //self.backgroundColor = highlighted ? [UIColor grayColor] : [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.backgroundColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
}

@end
