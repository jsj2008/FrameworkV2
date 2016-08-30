//
//  UBNothingIndicatorView.h
//  FrameworkV2
//
//  Created by ww on 16/8/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UBNothingIndicatorView
 
    @abstract
        空内容指示视图
 
 *********************************************************/

@interface UBNothingIndicatorView : UIView

@end


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
