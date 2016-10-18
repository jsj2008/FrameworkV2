//
//  UBToastView.h
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
@property (nonatomic, copy) NSAttributedString *attributedMessage;

/*!
 * @brief 选项
 */
@property (nonatomic) NSArray<NSAttributedString *> *attributedOptions;

/*!
 * @brief 选项选择回调block
 */
@property (nonatomic, copy) void (^optionOperation)(NSAttributedString *attributedOption);

/*!
 * @brief 取消回调block
 */
@property (nonatomic, copy) void (^cancelOperation)(void);

/*!
 * @brief 显示超时时间，超过时间自动执行取消操作
 * @discussion timeout <= 0，超时设置不生效
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


/*********************************************************
 
    @category
        UIView (Toast)
 
    @abstract
        UIView的提示框扩展
 
 *********************************************************/

@interface UIView (Toast)

/*!
 * @brief 弹出提示框
 * @discussion 默认超时时间3秒，超时、选中选项或点击取消提示框，提示框都将自动消失
 * @param attributedMessage 消息文本
 * @param attributedOptions 选项
 * @param completion 结束回调block，attributedOption为nil表征提示框被取消
 * @result 提示框
 */
- (void)toastWithAttributedMessage:(NSAttributedString *)attributedMessage attributedOptions:(NSArray<NSAttributedString *> *)attributedOptions completion:(void (^)(NSAttributedString *attributedOption))completion;

/*!
 * @brief 弹出提示框
 * @discussion 默认超时时间3秒，超时、选中选项或点击取消提示框，提示框都将自动消失
 * @param message 消息文本
 * @param options 选项
 * @param completion 结束回调block，option为nil表征提示框被取消
 * @result 提示框
 */
- (void)toastWithMessage:(NSString *)message options:(NSArray<NSString *> *)options completion:(void (^)(NSString *option))completion;

@end
