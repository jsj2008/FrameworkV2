//
//  UITextField+TextFieldInput.h
//  FrameworkV2
//
//  Created by ww on 18/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBTextFieldInput.h"

/*********************************************************
 
    @category
        UITextField (TextFieldInput)
 
    @abstract
        UITextField的输入扩展
 
 *********************************************************/

@interface UITextField (TextFieldInput)

/*!
 * @brief 自定义输入器
 * @discussion 在设置输入器属性前，请完成输入器的设置
 */
@property (nonatomic) UBTextFieldInput *textFieldInput;

@end
