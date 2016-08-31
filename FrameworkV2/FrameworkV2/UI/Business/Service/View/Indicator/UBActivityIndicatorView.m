//
//  UBActivityIndicatorView.m
//  FrameworkV2
//
//  Created by ww on 16/8/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBActivityIndicatorView.h"
#import <objc/runtime.h>

@implementation UBActivityIndicatorView

- (void)startAnimating
{
    _isAnimating = YES;
}

- (void)stopAnimating
{
    _isAnimating = NO;
}

@end


static const char kUIViewPropertyKey_ActivityIndicatorView[] = "activityIndicatorView";

static const char kUIViewPropertyKey_ActivityIndicatorCount[] = "activityIndicatorCount";


@implementation UIView (ActivityIndicator)

- (void)setActivityIndicatorView:(UBActivityIndicatorView *)activityIndicatorView
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_ActivityIndicatorView, activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (activityIndicatorView)
    {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
                                                 [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                                 [NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0], nil]];
    }
}

- (UBActivityIndicatorView *)activityIndicatorView
{
    return objc_getAssociatedObject(self, kUIViewPropertyKey_ActivityIndicatorView);
}

- (void)setActivityIndicatorCount:(NSUInteger)activityIndicatorCount
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_ActivityIndicatorCount, [NSNumber numberWithUnsignedInteger:activityIndicatorCount], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)activityIndicatorCount
{
    return [objc_getAssociatedObject(self, kUIViewPropertyKey_ActivityIndicatorCount) integerValue];
}

- (void)showActivityIndicator
{
    if (!self.activityIndicatorView)
    {
        self.activityIndicatorView = [[UBActivityIndicatorView alloc] init];
    }
    
    if (self.activityIndicatorCount == 0)
    {        
        [self addSubview:self.activityIndicatorView];
        
        [self.activityIndicatorView startAnimating];
    }
    
    self.activityIndicatorCount ++;
}

- (void)hideActivityIndicator
{
    self.activityIndicatorCount = 0;
    
    [self.activityIndicatorView stopAnimating];
    
    [self.activityIndicatorView removeFromSuperview];
}

- (void)hideActivityIndicatorCountly
{
    NSUInteger count = self.activityIndicatorCount;
    
    if (count > 0)
    {
        count --;
        
        if (count == 0)
        {
            [self hideActivityIndicator];
        }
    }
    
    self.activityIndicatorCount = count;
}

@end
