//
//  UBProgressIndicatorView.h
//  FrameworkV2
//
//  Created by ww on 16/8/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UBProgressIndicatorView
 
    @abstract
        进度指示视图
 
 *********************************************************/

@interface UBProgressIndicatorView : UIView

/*!
 * @brief 进度值
 */
@property (nonatomic) float progress;

@end


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
