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

/*!
 * @brief 更新输入器
 * @discussion 更新输入器将重置输入器，所有之前的数据操作全部失效
 * @discussion 只有更新输入器，输入器才能正常使用，因此在进行数据操作前，务必先更新输入器
 */
- (void)updateInput;

@end
