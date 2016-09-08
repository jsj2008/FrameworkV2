//
//  UBTextFieldDataPickerInput.m
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBTextFieldDataPickerInput.h"
#import "UFTextFieldDataPickerInput.h"

@interface UBTextFieldDataPickerInput () <UFTextFieldDataPickerInputDelegate>

@property (nonatomic) UFTextFieldDataPickerInput *input;

@end


@implementation UBTextFieldDataPickerInput

- (void)updateInput
{
    UFDataPickerDictionarySource *dataSource = [[UFDataPickerDictionarySource alloc] init];
    
    dataSource.data = self.data;
    
    dataSource.componentsNumber = self.componentsNumber;
    
    self.input = [[UFTextFieldDataPickerInput alloc] initWithTextField:self.textField dataPickSouce:dataSource inputAccessoryView:self.toolBar];
    
    self.input.delegate = self;
}

- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated
{
    [self.input setIndexes:indexes animated:animated];
}

- (void)didInputIndexes:(NSArray<NSNumber *> *)indexes
{
    
}

- (NSArray<NSString *> *)titlesAtIndexes:(NSArray<NSNumber *> *)indexes
{
    return [self.input titlesAtIndexes:indexes];
}

- (void)textFieldDataPickerInput:(UFTextFieldDataPickerInput *)input didSelectIndexes:(NSArray<NSNumber *> *)indexes
{
    [self didInputIndexes:indexes];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldInputDidUpdateInput:)])
    {
        [self.delegate textFieldInputDidUpdateInput:self];
    }
}

- (void)textFieldDataPickerInputDidCancel:(UFTextFieldDataPickerInput *)input
{
    [self didInputIndexes:nil];
}

@end
