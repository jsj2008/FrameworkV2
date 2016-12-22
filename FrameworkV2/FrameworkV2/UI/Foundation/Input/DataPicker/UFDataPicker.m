//
//  UFDataPicker.m
//  Test
//
//  Created by ww on 16/3/7.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFDataPicker.h"

@interface UFDataPicker () <UFDataPickerSourceDelegate>

// 由于UIPickerView在连续调用selectedRowInComponent:时会发生row始终等于0的情况（原因未知，连续调用起初能获取正确的row，随后会一直等于0），因此使用selectedIndexes来准确记录选择的row数组
@property (nonatomic) NSMutableArray<NSNumber *> *selectedIndexes;

@end


@implementation UFDataPicker

- (instancetype)initWithDataSource:(UFDataPickerSource *)dataSource
{
    if (self = [super init])
    {
        _pickerView = [[UIPickerView alloc] init];
        
        _pickerView.delegate = self;
        
        _pickerView.dataSource = self;
        
        _dataSource = dataSource;
        
        _dataSource.delegate = self;
        
        self.selectedIndexes = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [dataSource numberOfComponents]; i ++)
        {
            [self.selectedIndexes addObject:[NSNumber numberWithInteger:0]];
        }
    }
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dataSource numberOfComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSource numberOfRowsInComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataSource titleForRow:row forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.selectedIndexes replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    
    if (component < [self.dataSource numberOfComponents] - 1)
    {
        [pickerView reloadComponent:component + 1];
    }
}

- (NSInteger)dataPickerSource:(UFDataPickerSource *)source selectedRowInComponent:(NSInteger)component
{
    return [[self.selectedIndexes objectAtIndex:component] integerValue];
}

- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated
{
    for (int i = 0; i < [indexes count]; i ++)
    {
        NSNumber *index = [indexes objectAtIndex:i];
        
        [self.pickerView selectRow:[index integerValue] inComponent:i animated:animated];
    }
    
    [self.selectedIndexes setArray:indexes];
}

- (NSArray<NSNumber *> *)currentIndexes
{
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.selectedIndexes.count; i ++)
    {
        NSInteger index = [[self.selectedIndexes objectAtIndex:i] integerValue];
        
        NSInteger numberOfRowsInComponent = [self.dataSource numberOfRowsInComponent:i];
        
        if (numberOfRowsInComponent <= 0)
        {
            break;
        }
        else if (index > numberOfRowsInComponent - 1)
        {
            index = numberOfRowsInComponent - 1;
        }
        
        [indexes addObject:[NSNumber numberWithInteger:index]];
    }
    
    return indexes;
}

@end
