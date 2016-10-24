//
//  UBTextFieldTextInput.m
//  FrameworkV2
//
//  Created by ww on 18/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldTextInput.h"

@interface UBTextFieldTextInput ()

- (void)didEndEditing:(NSNotification *)notification;

@end


@implementation UBTextFieldTextInput

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateInput
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    self.textField.text = text;
}

- (void)didEndEditing:(NSNotification *)notification
{
    if (notification.object != self.textField)
    {
        return;
    }
    
    _text = [self.textField.text copy];
    
    if (self.completion)
    {
        self.completion();
    }
}

@end
