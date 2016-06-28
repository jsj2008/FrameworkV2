//
//  UFTextFieldDataPickerInput.m
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFTextFieldDataPickerInput.h"
#import "UFDataPickerInput.h"

@interface UFTextFieldDataPickerInput () <UFDataPickerInputDelegate>
{
    UITextField *_textField;
    
    UFDataPickerSource *_dataPickSource;
    
    UIView<UFDataPickerInputAccessory> *_inputAccessoryView;
}

@property (nonatomic) UFDataPickerInput *input;

@property (nonatomic) NSArray *originalIndexes;

- (void)didReceiveTextFieldDidBeginEditingNotification:(NSNotification *)notification;

@end


@implementation UFTextFieldDataPickerInput

@synthesize textField = _textField;

@synthesize dataPickSource = _dataPickSource;

@synthesize inputAccessoryView = _inputAccessoryView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTextField:(UITextField *)textField dataPickSouce:(UFDataPickerSource *)dataPickSouce inputAccessoryView:(UIView<UFDataPickerInputAccessory> *)inputAccessoryView
{
    if (self = [super init])
    {
        _textField = textField;
        
        _dataPickSource = dataPickSouce;
        
        _inputAccessoryView = inputAccessoryView;
                
        UFDataPicker *picker = [[UFDataPicker alloc] initWithDataSource:dataPickSouce];
        
        self.input = [[UFDataPickerInput alloc] initWithDataPicker:picker accessory:inputAccessoryView];
        
        self.input.delegate = self;
        
        textField.inputView = picker.pickerView;
        
        textField.inputAccessoryView = inputAccessoryView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextFieldDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    }
    
    return self;
}

- (void)setIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    [self.input setIndexes:indexes animated:animated];
}

- (NSArray *)titlesAtIndexes:(NSArray *)indexes
{
    return [self.dataPickSource titlesAtIndexes:indexes];
}

- (void)dataPickerInput:(UFDataPickerInput *)input didSelectIndexes:(NSArray<NSNumber *> *)indexes
{
    [self.textField endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDataPickerInput:didSelectIndexes:)])
    {
        [self.delegate textFieldDataPickerInput:self didSelectIndexes:indexes];
    }
}

- (void)dataPickerInputDidCancel:(UFDataPickerInput *)input
{
    [self.textField endEditing:YES];
    
    [self.input setIndexes:self.originalIndexes animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDataPickerInputDidCancel:)])
    {
        [self.delegate textFieldDataPickerInputDidCancel:self];
    }
}

- (void)didReceiveTextFieldDidBeginEditingNotification:(NSNotification *)notification
{
    if ([self.textField isFirstResponder])
    {
        self.originalIndexes = [self.input.dataPicker currentIndexes];
    }
}

@end
