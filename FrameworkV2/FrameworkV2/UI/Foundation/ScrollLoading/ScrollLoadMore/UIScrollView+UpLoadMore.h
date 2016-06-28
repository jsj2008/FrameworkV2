//
//  UIScrollView+UpLoadMore.h
//  Test
//
//  Created by ww on 16/5/9.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFScrollLoadMoreFooterView.h"

/*********************************************************
 
    @category
        UIScrollView (UpLoadMore)
 
    @abstract
        UIScrollView的上拉加载更多扩展
 
 *********************************************************/

@interface UIScrollView (LoadMoreFooter)

/*!
 * @brief 上拉加载更多视图
 */
@property (nonatomic) UFScrollLoadMoreFooterView *upLoadMoreFooterView;

@end
