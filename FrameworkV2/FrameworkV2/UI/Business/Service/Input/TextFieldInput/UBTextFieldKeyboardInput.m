//
//  UBTextFieldKeyboardInput.m
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBTextFieldKeyboardInput.h"

@interface UBTextFieldKeyboardInput ()

- (void)didEndEditing;

@end


@implementation UBTextFieldKeyboardInput

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTextField:(UITextField *)textField
{
    if (self = [super initWithTextField:textField])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing) name:UITextFieldTextDidEndEditingNotification object:nil];
    }
    
    return self;
}

- (void)didInputText:(NSString *)text
{
    
}

- (void)didEndEditing
{
    if ([self.textField isFirstResponder])
    {
        [self didInputText:self.textField.text];
    }
}

@end
