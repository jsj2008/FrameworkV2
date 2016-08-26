//
//  UIView+Toast.h
//  FrameworkV2
//
//  Created by ww on 16/8/26.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

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
