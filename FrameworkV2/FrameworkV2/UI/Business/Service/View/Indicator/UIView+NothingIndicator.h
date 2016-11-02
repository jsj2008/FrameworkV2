//
//  UIView+NothingIndicator.h
//  FrameworkV2
//
//  Created by ww on 02/11/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBNothingIndicatorView.h"

/*********************************************************
 
    @category
        UIView (NothingIndicator)
 
    @abstract
        UIView的空内容指示视图扩展
 
 *********************************************************/

@interface UIView (NothingIndicator)

/*!
 * @brief 空内容指示视图
 */
@property (nonatomic) UBNothingIndicatorView *nothingIndicatorView;

/*!
 * @brief 显示空内容指示视图
 */
- (void)showNothingIndicator;

/*!
 * @brief 隐藏空内容指示视图
 */
- (void)hideNothingIndicator;

@end
