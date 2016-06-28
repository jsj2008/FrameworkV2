//
//  UIScrollView+RefreshHeader.h
//  Test
//
//  Created by ww on 16/5/9.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFScrollRefreshHeaderView.h"

/*********************************************************
 
    @category
        UIScrollView (DownRefresh)
 
    @abstract
        UIScrollView的下拉刷新扩展
 
 *********************************************************/

@interface UIScrollView (RefreshHeader)

/*!
 * @brief 下拉刷新视图
 */
@property (nonatomic) UFScrollRefreshHeaderView *refreshHeaderView;

@end
