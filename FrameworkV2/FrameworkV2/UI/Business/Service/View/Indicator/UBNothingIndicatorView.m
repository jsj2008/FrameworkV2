//
//  UBNothingIndicatorView.m
//  FrameworkV2
//
//  Created by ww on 16/8/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBNothingIndicatorView.h"
#import <objc/runtime.h>

@implementation UBNothingIndicatorView

@end


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
    
    [self addSubview:self.nothingIndicatorView];
}

- (void)hideNothingIndicator
{
    [self.nothingIndicatorView removeFromSuperview];
}

@end
