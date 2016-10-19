//
//  UBTextFieldBirthdayInput.m
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldBirthdayInput.h"
#import "UBTextFieldInputToolBar.h"

@interface UBTextFieldBirthdayInput () <UBTextFieldInputToolBarDelegate>

@property (nonatomic) UIDatePicker *datePicker;

@property (nonatomic) UBTextFieldInputToolBar *toolBar;

@end


@implementation UBTextFieldBirthdayInput

- (void)setTextField:(UITextField *)textField
{
    [super setTextField:textField];
    
    self.datePicker = [[UIDatePicker alloc] init];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.datePicker.minimumDate = self.minDate;
    
    self.datePicker.maximumDate = self.maxDate;
    
    textField.inputView = self.datePicker;
    
    self.toolBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UBTextFieldInputToolBar class]) owner:nil options:nil] firstObject];
    
    self.toolBar.delegate = self;
    
    textField.inputAccessoryView = self.toolBar;
}

- (void)setBirthday:(NSDate *)birthday
{
    _birthday = birthday;
    
    self.datePicker.date = birthday ? birthday : self.minDate;
    
    self.textField.text = birthday ? [birthday description] : nil;
}

- (void)textFieldInputToolBarDidConfirm:(UBTextFieldInputToolBar *)toolBar
{
    _birthday = [self.datePicker.date copy];
    
    self.textField.text = [_birthday description];
    
    [self.textField endEditing:YES];
    
    if (self.completion)
    {
        self.completion();
    }
}

- (void)textFieldInputToolBarDidCancel:(UBTextFieldInputToolBar *)toolBar
{
    [self.textField endEditing:YES];
}

@end
