//
//  UBTextFieldInput.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @brief TextField数据输入的完成回调
 */
typedef void(^UBTextFieldInputCompletion)(void);

/*********************************************************
 
    @class
        UBTextFieldInput
 
    @abstract
        TextField数据输入器
 
    @discussion
        UBTextFieldInput是抽象类
 
 *********************************************************/

@interface UBTextFieldInput : NSObject

/*!
 * @brief 文本输入框
 */
@property (nonatomic, weak) UITextField *textField;

/*!
 * @brief 输入数据的完成回调
 */
@property (nonatomic, copy) UBTextFieldInputCompletion completion;

@end
