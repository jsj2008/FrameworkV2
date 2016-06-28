//
//  UBToastView+ToastType.h
//  FrameworkV1
//
//  Created by ww on 16/5/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBToastView.h"

/*********************************************************
 
    @category
        UBToastView (ToastType)
 
    @abstract
        UBToastView的类型扩展
 
 *********************************************************/

@interface UBToastView (ToastType)

/*!
 * @brief 提示框
 * @discussion 默认超时时间3秒
 * @param message 消息文本
 * @param options 选项
 * @param completion 结束回调block，option为nil表征提示框被取消
 * @result 提示框
 */
+ (UBToastView *)toastViewWithMessage:(NSString *)message options:(NSArray<NSString *> *)options completion:(void (^)(NSString *option))completion;

@end
