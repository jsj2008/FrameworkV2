//
//  UFInputButton.h
//  FrameworkV2
//
//  Created by ww on 16/6/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFInputButton
 
    @abstract
        可触发输入的按钮
 
 *********************************************************/

@interface UFInputButton : UIButton

/*!
 * @brief 输入视图
 */
@property (nonatomic) UIView *inputView;

/*!
 * @brief 输入辅助视图
 */
@property (nonatomic) UIView *inputAccessoryView;

/*!
 * @brief 显示输入
 */
- (void)showInput;

/*!
 * @brief 隐藏输入
 */
- (void)hideInput;

@end
