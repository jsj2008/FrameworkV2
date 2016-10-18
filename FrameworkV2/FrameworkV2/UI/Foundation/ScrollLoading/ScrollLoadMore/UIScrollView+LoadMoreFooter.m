//
//  UIScrollView+LoadMoreFooter.m
//  Test
//
//  Created by ww on 16/5/9.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UIScrollView+LoadMoreFooter.h"
#import <objc/runtime.h>

static const char kUIScrollViewPropertyKey_LoadMoreFooterView[] = "loadMoreFooterView";


@implementation UIScrollView (LoadMoreFooter)

- (void)setLoadMoreFooterView:(UFScrollLoadMoreFooterView *)loadMoreFooterView
{
    if (self.loadMoreFooterView == loadMoreFooterView)
    {
        ;
    }
    else
    {
        [self.loadMoreFooterView removeFromSuperview];
        
        objc_setAssociatedObject(self, kUIScrollViewPropertyKey_LoadMoreFooterView, loadMoreFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (loadMoreFooterView)
        {
            [self addSubview:loadMoreFooterView];
        }
    }
}

- (UFScrollLoadMoreFooterView *)loadMoreFooterView
{
    return objc_getAssociatedObject(self, kUIScrollViewPropertyKey_LoadMoreFooterView);
}

@end
