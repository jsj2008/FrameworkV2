//
//  UBTextFieldHeightInput.m
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldHeightInput.h"
#import "UFDataPicker.h"
#import "UBTextFieldInputToolBar.h"

@interface UBTextFieldHeightInput () <UBTextFieldInputToolBarDelegate>

@property (nonatomic) UFDataPicker *dataPicker;

@property (nonatomic) UBTextFieldInputToolBar *toolBar;

@property (nonatomic) NSArray<NSString *> *heights;

@end


@implementation UBTextFieldHeightInput

- (instancetype)init
{
    if (self = [super init])
    {
        self.minHeight = 140;
        
        self.maxHeight = 200;
    }
    
    return self;
}

- (void)setTextField:(UITextField *)textField
{
    [super setTextField:textField];
    
    NSMutableArray *heights = [[NSMutableArray alloc] init];
    
    for (NSInteger i = self.minHeight; i < self.maxHeight; i ++)
    {
        [heights addObject:[NSString stringWithFormat:@"%ldcm", (long)i]];
    }
    
    self.heights = heights;
    
    UFDataPickerDictionarySource *dataSource = [[UFDataPickerDictionarySource alloc] init];
    
    dataSource.data = [NSDictionary dictionaryWithObject:heights forKey:@""];
    
    dataSource.componentsNumber = 1;
    
    self.dataPicker = [[UFDataPicker alloc] initWithDataSource:dataSource];
    
    textField.inputView = self.dataPicker.pickerView;
    
    self.toolBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UBTextFieldInputToolBar class]) owner:nil options:nil] firstObject];
    
    self.toolBar.delegate = self;
    
    textField.inputAccessoryView = self.toolBar;
}

- (void)setHeight:(NSNumber *)height
{
    _height = height;
    
    NSInteger index = [height integerValue] - self.minHeight;
    
    if (index < 0)
    {
        index = 0;
    }
    else if (index > self.heights.count - 1)
    {
        index = self.heights.count - 1;
    }
    
    [self.dataPicker setIndexes:[NSArray arrayWithObject:[NSNumber numberWithInteger:index]] animated:NO];
    
    self.textField.text = height ? [NSString stringWithFormat:@"%@cm", height] : nil;
}

- (void)textFieldInputToolBarDidConfirm:(UBTextFieldInputToolBar *)toolBar
{
    NSInteger index = [[[self.dataPicker currentIndexes] firstObject] integerValue];
    
    _height = [NSNumber numberWithInteger:index + self.minHeight];
    
    self.textField.text = [NSString stringWithFormat:@"%@cm", _height];
    
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
