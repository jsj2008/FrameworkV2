//
//  UBTextFieldYMDDateInput.m
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldYMDDateInput.h"
#import "UBTextFieldInputToolBar.h"

@interface UBTextFieldYMDDateInput () <UBTextFieldInputToolBarDelegate>

@property (nonatomic) UIDatePicker *datePicker;

@property (nonatomic) UBTextFieldInputToolBar *toolBar;

- (NSString *)textForDate:(NSDate *)date;

@end


@implementation UBTextFieldYMDDateInput

- (instancetype)init
{
    if (self = [super init])
    {
        self.minDate = [NSDate dateWithTimeIntervalSince1970:0];
        
        self.maxDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return self;
}

- (void)updateInput
{
    self.datePicker = [[UIDatePicker alloc] init];
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.datePicker.minimumDate = self.minDate;
    
    self.datePicker.maximumDate = self.maxDate;
    
    self.textField.inputView = self.datePicker;
    
    self.toolBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UBTextFieldInputToolBar class]) owner:nil options:nil] firstObject];
    
    self.toolBar.delegate = self;
    
    self.textField.inputAccessoryView = self.toolBar;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    self.datePicker.date = date ? date : self.minDate;
    
    self.textField.text = [self textForDate:date];
}

- (void)textFieldInputToolBarDidConfirm:(UBTextFieldInputToolBar *)toolBar
{
    _date = [self.datePicker.date copy];
    
    self.textField.text = [self textForDate:_date];
    
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

- (NSString *)textForDate:(NSDate *)date
{
    NSString *text = nil;
    
    if (date)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
        
        text = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)components.year, (long)components.month, (long)components.day];
    }
    
    return text;
}

@end
