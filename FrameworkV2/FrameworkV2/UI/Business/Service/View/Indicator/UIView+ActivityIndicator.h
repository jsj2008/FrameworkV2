//
//  UIView+ActivityIndicator.h
//  FrameworkV2
//
//  Created by ww on 02/11/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBActivityIndicatorView.h"

/*********************************************************
 
    @category
        UIView (ActivityIndicator)
 
    @abstract
        UIView的活动指示视图扩展
 
 *********************************************************/

@interface UIView (ActivityIndicator)

/*!
 * @brief 活动指示视图
 */
@property (nonatomic) UBActivityIndicatorView *activityIndicatorView;

/*!
 * @brief 活动指示视图计数
 */
@property (nonatomic) NSUInteger activityIndicatorCount;

/*!
 * @brief 显示活动指示视图
 * @discussion 每次显示，都会增加一次视图计数
 */
- (void)showActivityIndicator;

/*!
 * @brief 隐藏活动指示视图
 * @discussion 隐藏时将会清空视图计数
 */
- (void)hideActivityIndicator;

/*!
 * @brief 根据计数隐藏活动指示视图
 * @discussion 每调用一次，视图计数减1，减至0时隐藏视图，不为0时不隐藏
 */
- (void)hideActivityIndicatorCountly;

@end

