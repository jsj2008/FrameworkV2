//
//  UBTextFieldPCLocationInput.m
//  FrameworkV2
//
//  Created by ww on 19/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldPCLocationInput.h"
#import "UFDataPicker.h"
#import "UBTextFieldInputToolBar.h"

@interface UBTextFieldPCLocationInput () <UBTextFieldInputToolBarDelegate>

@property (nonatomic) UFDataPicker *dataPicker;

@property (nonatomic) UBTextFieldInputToolBar *toolBar;

@property (nonatomic) NSArray<NSDictionary<NSString *, NSArray<NSString *> *> *> *locations;

- (NSString *)textForLocation:(UBTextFieldInputPCLocation *)location;

@end


@implementation UBTextFieldPCLocationInput

- (void)updateInput
{
    NSString *pcPath = [[NSBundle mainBundle] pathForResource:@"scity" ofType:@"plist"];
    
    self.locations = [[NSArray alloc] initWithContentsOfFile:pcPath];
    
    UFDataPickerDictionarySource *dataSource = [[UFDataPickerDictionarySource alloc] init];
    
    dataSource.data = [NSDictionary dictionaryWithObject:self.locations forKey:@""];
    
    dataSource.componentsNumber = 2;
    
    self.dataPicker = [[UFDataPicker alloc] initWithDataSource:dataSource];
    
    self.textField.inputView = self.dataPicker.pickerView;
    
    self.toolBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UBTextFieldInputToolBar class]) owner:nil options:nil] firstObject];
    
    self.toolBar.delegate = self;
    
    self.textField.inputAccessoryView = self.toolBar;
}

- (void)setLocation:(UBTextFieldInputPCLocation *)location
{
    _location = location;
    
    NSInteger provinceIndex = 0;
    
    NSInteger cityIndex = 0;
    
    if (location.province && location.city)
    {
        for (NSInteger i = 0; i < self.locations.count; i ++)
        {
            NSDictionary *provinceLocations = [self.locations objectAtIndex:i];
            
            NSString *province = [[provinceLocations allKeys] firstObject];
            
            if ([location.province isEqualToString:province])
            {
                NSArray *cityLocations = [provinceLocations objectForKey:province];
                
                NSInteger indexOfCity = [cityLocations indexOfObject:location.city];
                
                if (indexOfCity != NSNotFound)
                {
                    provinceIndex = i;
                    
                    cityIndex = indexOfCity;
                    
                    break;
                }
            }
        }
    }
    
    [self.dataPicker setIndexes:[NSArray arrayWithObjects:[NSNumber numberWithInteger:provinceIndex], [NSNumber numberWithInteger:cityIndex], nil] animated:NO];
    
    self.textField.text = [self textForLocation:location];
}

- (void)textFieldInputToolBarDidConfirm:(UBTextFieldInputToolBar *)toolBar
{
    NSArray *indexes = [self.dataPicker currentIndexes];
    
    if (indexes.count == [self.dataPicker.dataSource numberOfComponents])
    {
        NSInteger provinceIndex = [[indexes firstObject] integerValue];
        
        NSInteger cityIndex = [[indexes lastObject] integerValue];
        
        NSDictionary *provinceLocations = [self.locations objectAtIndex:provinceIndex];
        
        NSString *province = [[provinceLocations allKeys] firstObject];
        
        NSString *city = [(NSArray *)[provinceLocations objectForKey:province] objectAtIndex:cityIndex];
        
        UBTextFieldInputPCLocation *location = [[UBTextFieldInputPCLocation alloc] init];
        
        location.province = province;
        
        location.city = city;
        
        _location = location;
    }
    else
    {
        _location = nil;
    }
    
    self.textField.text = [self textForLocation:_location];
    
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

- (NSString *)textForLocation:(UBTextFieldInputPCLocation *)location
{
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    
    if (location.province.length > 0)
    {
        [strings addObject:location.province];
    }
    
    if (location.city.length > 0)
    {
        [strings addObject:location.city];
    }
    
    return [strings componentsJoinedByString:@"-"];
}

@end
