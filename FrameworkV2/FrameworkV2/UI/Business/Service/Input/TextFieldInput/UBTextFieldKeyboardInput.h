//
//  UBTextFieldKeyboardInput.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBTextFieldInput.h"

/*********************************************************
 
    @class
        UBTextFieldKeyboardInput
 
    @abstract
        TextField键盘输入器，弹出键盘输入
 
 *********************************************************/

@interface UBTextFieldKeyboardInput : UBTextFieldInput

/*!
 * @brief 已输入文本
 * @param text 输入的文本
 * @discussion 在此处理文本输入后的逻辑
 * @discussion 此方法默认不执行任何操作，子类可重写本方法实现自定义的功能
 */
- (void)didInputText:(NSString *)text;

@end
