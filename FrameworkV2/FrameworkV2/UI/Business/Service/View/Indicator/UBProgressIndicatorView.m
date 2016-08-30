//
//  UBProgressIndicatorView.m
//  FrameworkV2
//
//  Created by ww on 16/8/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBProgressIndicatorView.h"
#import <objc/runtime.h>

@implementation UBProgressIndicatorView

@end


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
    
    [self addSubview:self.progressIndicatorView];
}

- (void)hideProgressIndicator
{
    [self.progressIndicatorView removeFromSuperview];
}

@end
