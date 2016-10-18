//
//  UIScrollView+RefreshHeader.m
//  Test
//
//  Created by ww on 16/5/9.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UIScrollView+RefreshHeader.h"
#import <objc/runtime.h>

static const char kUIScrollViewPropertyKey_RefreshHeaderView[] = "refreshHeaderView";


@implementation UIScrollView (RefreshHeader)

- (void)setRefreshHeaderView:(UFScrollRefreshHeaderView *)refreshHeaderView
{
    if (self.refreshHeaderView == refreshHeaderView)
    {
        ;
    }
    else
    {
        [self.refreshHeaderView removeFromSuperview];
                
        objc_setAssociatedObject(self, kUIScrollViewPropertyKey_RefreshHeaderView, refreshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (refreshHeaderView)
        {
            [self addSubview:refreshHeaderView];
        }
    }
}

- (UFScrollRefreshHeaderView *)refreshHeaderView
{
    return objc_getAssociatedObject(self, kUIScrollViewPropertyKey_RefreshHeaderView);
}

@end
