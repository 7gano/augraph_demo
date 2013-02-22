//
//  NNSequenceView.m
//  DrumMachine
//
//  Created by 7gano on 02/22/13.
//

#import "NNSequenceView.h"
#import "NNStepsView.h"

@implementation NNSequenceView

//----------------------------------------------------------------------------//
#pragma mark -- Initialize --
//----------------------------------------------------------------------------//

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (nil == self) {
        return nil;
    }
    
    _tracks = [[NSMutableArray alloc] init];
    
    CGRect rect  = self.bounds;
    rect.size.height = CGRectGetHeight(self.bounds) / 4.0;
    for (NSUInteger i = 0; i < 4; i++) {
        NNStepsView *stepsView = [[NNStepsView alloc] initWithFrame:rect];
        stepsView.delegate = self;
        [_tracks addObject:stepsView];
        [self addSubview:stepsView];
    }
    return self;
}

//----------------------------------------------------------------------------//
#pragma mark -- Action --
//----------------------------------------------------------------------------//

- (void)updateStatus:(NSArray*)status
{
    for (NSUInteger i = 0; i < 4; i++) {
        NSString *string = [status objectAtIndex:i];
        NNStepsView *stepsView = [_tracks objectAtIndex:i];
        [stepsView setStatus:string];
    }
}

//----------------------------------------------------------------------------//
#pragma mark -- View --
//----------------------------------------------------------------------------//

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.height = CGRectGetHeight(self.bounds) / 4.0;
    rect.size.height = 40;
    
    for (NNStepsView *stepsView in _tracks) {
        stepsView.frame = rect;
        rect.origin.y += CGRectGetHeight(rect) + 10;
    }
}

- (void)stepsView:(NNStepsView*)stepsView didTapAtIndex:(NSUInteger)index
{
    NSUInteger trackIndex = [_tracks indexOfObject:stepsView];
    if([self.delegate respondsToSelector:@selector(sequenceView:didTapTrackAtIndex:step:)]){
        [self.delegate sequenceView:self didTapTrackAtIndex:trackIndex step:index];
    }
}

@end
