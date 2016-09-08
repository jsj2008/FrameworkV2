//
//  UBActivityIndicatorView.h
//  FrameworkV2
//
//  Created by ww on 16/8/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UBActivityIndicatorView
 
    @abstract
        活动指示视图
 
    @discussion
        支持动画效果
 
 *********************************************************/

@interface UBActivityIndicatorView : UIView

/*!
 * @brief 是否动画
 */
@property (nonatomic, readonly) BOOL isAnimating;

/*!
 * @brief 启动动画
 */
- (void)startAnimating;

/*!
 * @brief 停止动画
 */
- (void)stopAnimating;

@end


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
