//
//  UIView+NothingIndicator.m
//  FrameworkV2
//
//  Created by ww on 02/11/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UIView+NothingIndicator.h"
#import <objc/runtime.h>

static const char kUIViewPropertyKey_NothingIndicatorView[] = "nothingIndicatorView";


@implementation UIView (NothingIndicator)

- (void)setNothingIndicatorView:(UBNothingIndicatorView *)nothingIndicatorView
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_NothingIndicatorView, nothingIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UBNothingIndicatorView *)nothingIndicatorView
{
    return objc_getAssociatedObject(self, kUIViewPropertyKey_NothingIndicatorView);
}

- (void)showNothingIndicator
{
    if (!self.nothingIndicatorView)
    {
        self.nothingIndicatorView = [[UBNothingIndicatorView alloc] init];
    }
    
    if (!self.nothingIndicatorView.superview)
    {
        [self addSubview:self.nothingIndicatorView];
        
        self.nothingIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
                                                 [NSLayoutConstraint constraintWithItem:self.nothingIndicatorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:self.nothingIndicatorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:self.nothingIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:self.nothingIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0], nil]];
    }
    
    [self bringSubviewToFront:self.nothingIndicatorView];
}

- (void)hideNothingIndicator
{
    [self.nothingIndicatorView removeFromSuperview];
}

@end
