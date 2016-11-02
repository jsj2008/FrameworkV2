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
