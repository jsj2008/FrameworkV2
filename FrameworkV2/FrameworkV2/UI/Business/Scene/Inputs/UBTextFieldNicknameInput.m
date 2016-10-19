//
//  UBTextFieldNicknameInput.m
//  FrameworkV2
//
//  Created by ww on 18/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldNicknameInput.h"

@interface UBTextFieldNicknameInput ()

- (void)didEndEditing:(NSNotification *)notification;

@end


@implementation UBTextFieldNicknameInput

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextField:(UITextField *)textField
{
    [super setTextField:textField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)setNickname:(NSString *)nickname
{
    _nickname = [nickname copy];
    
    self.textField.text = nickname;
}

- (void)didEndEditing:(NSNotification *)notification
{
    if (notification.object != self.textField)
    {
        return;
    }
    
    _nickname = [self.textField.text copy];
    
    if (self.completion)
    {
        self.completion();
    }
}

@end
