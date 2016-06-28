//
//  UBToast.h
//  FrameworkV1
//
//  Created by ww on 16/5/18.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UBToastView
 
    @abstract
        提示框
 
    @discussion
        1，与UIAlertView类似，支持消息文本和按钮选项
        2，提供显示超时功能，超过时间自动消失
 
 *********************************************************/

@interface UBToastView : UIView

/*!
 * @brief 消息文本
 */
@property (nonatomic) NSAttributedString *attributedMessage;

/*!
 * @brief 选项
 */
@property (nonatomic) NSArray<NSAttributedString *> *attributedOptions;

/*!
 * @brief 选项选择回调block
 */
@property (nonatomic) void (^optionOperation)(NSAttributedString *attributedOption);

/*!
 * @brief 取消回调block
 */
@property (nonatomic) void (^cancelOperation)(void);

/*!
 * @brief 显示超时时间，超过时间自定执行取消操作
 */
@property (nonatomic) NSTimeInterval timeout;

/*!
 * @brief 在指定视图中显示
 * @discussion 显示时，提示框作为指定视图的子视图，自动撑满指定视图，当指定视图消失时，提示框一同消失
 * @param view 指定显示视图
 */
- (void)showInView:(UIView *)view;

/*!
 * @brief 消失，从父视图上移除
 */
- (void)dismiss;

@end
