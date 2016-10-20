//
//  UBTextFieldHeightRangeInput.m
//  FrameworkV2
//
//  Created by ww on 19/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldHeightRangeInput.h"
#import "UFDataPicker.h"
#import "UBTextFieldInputToolBar.h"

@interface UBTextFieldHeightRangeInput () <UBTextFieldInputToolBarDelegate>

@property (nonatomic) UFDataPicker *dataPicker;

@property (nonatomic) UBTextFieldInputToolBar *toolBar;

@property (nonatomic) NSArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *ranges;

- (NSString *)textForRange:(UBTextFieldInputHeightRange *)range;

@end


@implementation UBTextFieldHeightRangeInput

- (void)setTextField:(UITextField *)textField
{
    [super setTextField:textField];
    
    NSMutableArray *ranges = [[NSMutableArray alloc] init];
    
    for (NSInteger i = self.minHeight; i <= self.maxHeight; i ++)
    {
        NSString *minHeight = [NSString stringWithFormat:@"%ld", (long)i];
        
        NSMutableArray *maxHeights = [[NSMutableArray alloc] init];
        
        for (NSInteger j = i; j <= self.maxHeight; j ++)
        {
            NSString *maxHeight = [NSString stringWithFormat:@"%ld", (long)j];
            
            [maxHeights addObject:maxHeight];
        }
        
        [ranges addObject:[NSDictionary dictionaryWithObject:maxHeights forKey:minHeight]];
    }
    
    self.ranges = ranges;
    
    UFDataPickerDictionarySource *dataSource = [[UFDataPickerDictionarySource alloc] init];
    
    dataSource.data = [NSDictionary dictionaryWithObject:ranges forKey:@""];
    
    dataSource.componentsNumber = 1;
    
    self.dataPicker = [[UFDataPicker alloc] initWithDataSource:dataSource];
    
    textField.inputView = self.dataPicker.pickerView;
    
    self.toolBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UBTextFieldInputToolBar class]) owner:nil options:nil] firstObject];
    
    self.toolBar.delegate = self;
    
    textField.inputAccessoryView = self.toolBar;
}

- (void)setHeightRange:(UBTextFieldInputHeightRange *)heightRange
{
    _heightRange = heightRange;
    
    NSInteger minIndex = 0;
    
    NSInteger maxIndex = 0;
    
    if (heightRange)
    {
        NSInteger minHeight = heightRange.minHeight;
        
        if (minHeight < self.minHeight)
        {
            minHeight = self.minHeight;
        }
        else if (minHeight > self.maxHeight)
        {
            minHeight = self.maxHeight;
        }
        
        minIndex = minHeight - self.minHeight;
        
        NSInteger maxHeight = heightRange.maxHeight;
        
        if (maxHeight < minHeight)
        {
            maxHeight = minHeight;
        }
        else if (maxHeight > self.maxHeight)
        {
            maxHeight = self.maxHeight;
        }
        
        maxIndex = maxHeight - minHeight;
    }
    
    [self.dataPicker setIndexes:[NSArray arrayWithObjects:[NSNumber numberWithInteger:minIndex], [NSNumber numberWithInteger:maxIndex], nil] animated:NO];
    
    self.textField.text = [self textForRange:heightRange];
}

- (void)textFieldInputToolBarDidConfirm:(UBTextFieldInputToolBar *)toolBar
{
    NSArray *indexes = [self.dataPicker currentIndexes];
    
    if (indexes.count == [self.dataPicker.dataSource numberOfComponents])
    {
        NSInteger minIndex = [[indexes firstObject] integerValue];
        
        NSInteger maxIndex = [[indexes lastObject] integerValue];
        
        UBTextFieldInputHeightRange *range = [[UBTextFieldInputHeightRange alloc] init];
        
        range.minHeight = self.minHeight + minIndex;
        
        range.maxHeight = range.minHeight + maxIndex;
        
        _heightRange = range;
    }
    else
    {
        _heightRange = nil;
    }
    
    self.textField.text = [self textForRange:_heightRange];
    
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

- (NSString *)textForRange:(UBTextFieldInputHeightRange *)range
{
    return [NSString stringWithFormat:@"%ld-%ld", (long)range.minHeight, (long)range.maxHeight];
}

@end
