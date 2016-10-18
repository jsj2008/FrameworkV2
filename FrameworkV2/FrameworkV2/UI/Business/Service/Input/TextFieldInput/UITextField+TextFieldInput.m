//
//  UITextField+TextFieldInput.m
//  FrameworkV2
//
//  Created by ww on 18/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UITextField+TextFieldInput.h"
#import <objc/runtime.h>

static const char kUITextFieldPropertyKey_TextFieldInput[] = "textFieldInput";


@implementation UITextField (TextFieldInput)

- (void)setTextFieldInput:(UBTextFieldInput *)textFieldInput
{
    objc_setAssociatedObject(self, kUITextFieldPropertyKey_TextFieldInput, textFieldInput, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    textFieldInput.textField = self;
}

- (UBTextFieldInput *)textFieldInput
{
    return objc_getAssociatedObject(self, kUITextFieldPropertyKey_TextFieldInput);
}

@end
