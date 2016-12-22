//
//  UIView+ProgressIndicator.h
//  FrameworkV2
//
//  Created by ww on 02/11/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBProgressIndicatorView.h"

/*********************************************************
 
    @category
        UIView (ProgressIndicator)
 
    @abstract
        UIView的进度指示视图扩展
 
 *********************************************************/

@interface UIView (ProgressIndicator)

/*!
 * @brief 进度指示视图
 */
@property (nonatomic) UBProgressIndicatorView *progressIndicatorView;

/*!
 * @brief 进度指示值
 */
@property (nonatomic) float progressIndicatorProgressValue;

/*!
 * @brief 显示进度指示视图
 */
- (void)showProgressIndicator;

/*!
 * @brief 隐藏进度指示视图
 */
- (void)hideProgressIndicator;

@end

