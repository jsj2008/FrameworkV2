//
//  UIView+ProgressIndicator.m
//  FrameworkV2
//
//  Created by ww on 02/11/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UIView+ProgressIndicator.h"
#import <objc/runtime.h>

static const char kUIViewPropertyKey_ProgressIndicatorView[] = "progressIndicatorView";

static const char kUIViewPropertyKey_ProgressIndicatorProgressValue[] = "progressIndicatorProgressValue";


@implementation UIView (ProgressIndicator)

- (void)setProgressIndicatorView:(UBProgressIndicatorView *)progressIndicatorView
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_ProgressIndicatorView, progressIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UBProgressIndicatorView *)progressIndicatorView
{
    return objc_getAssociatedObject(self, kUIViewPropertyKey_ProgressIndicatorView);
}

- (void)setProgressIndicatorProgressValue:(float)progressIndicatorProgressValue
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_ProgressIndicatorProgressValue, [NSNumber numberWithFloat:progressIndicatorProgressValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.progressIndicatorView.progress = progressIndicatorProgressValue;
}

- (float)progressIndicatorProgressValue
{
    return [objc_getAssociatedObject(self, kUIViewPropertyKey_ProgressIndicatorProgressValue) floatValue];
}

- (void)showProgressIndicator
{
    if (!self.progressIndicatorView)
    {
        self.progressIndicatorView = [[UBProgressIndicatorView alloc] init];
    }
    
    if (!self.progressIndicatorView.superview)
    {
        [self addSubview:self.progressIndicatorView];
        
        self.progressIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
                                                 [NSLayoutConstraint constraintWithItem:self.progressIndicatorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:self.progressIndicatorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:self.progressIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:self.progressIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0], nil]];
    }
    
    [self bringSubviewToFront:self.progressIndicatorView];
}

- (void)hideProgressIndicator
{
    [self.progressIndicatorView removeFromSuperview];
}

@end
