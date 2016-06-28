//
//  UBAgeRangeInput.m
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBAgeRangeInput.h"
#import "UBDefaultTextFieldDataPickerInputToolBar.h"

@implementation UBAgeRangeInput

- (instancetype)initWithTextField:(UITextField *)textField
{
    if (self = [super initWithTextField:textField])
    {
        NSMutableArray *ages = [[NSMutableArray alloc] init];
        
        for (int i = 15; i < 80; i ++)
        {
            NSMutableArray *ages1 = [[NSMutableArray alloc] init];
            
            for (int j = i; j < 80; j ++)
            {
                [ages1 addObject:[NSString stringWithFormat:@"%d", j]];
            }
            
            [ages addObject:[NSDictionary dictionaryWithObject:ages1 forKey:[NSString stringWithFormat:@"%d", i]]];
        }
        
        self.data = [NSDictionary dictionaryWithObject:ages forKey:@""];
        
        self.componentsNumber = 2;
        
        self.toolBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UBDefaultTextFieldDataPickerInputToolBar class]) owner:nil options:nil] firstObject];
        
        [self updateInput];
    }
    
    return self;
}

- (void)setFromAge:(NSUInteger)fromAge toAge:(NSUInteger)toAge
{
    _fromAge = fromAge;
    
    _toAge = toAge;
    
    if (fromAge >= 15 && toAge >= fromAge)
    {
        NSUInteger fromIndex = fromAge - 15;
        
        NSUInteger toIndex = toAge - fromAge;
        
        [self setIndexes:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:fromIndex], [NSNumber numberWithUnsignedInteger:toIndex], nil] animated:YES];
    }
    else
    {
        [self setIndexes:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:0], [NSNumber numberWithUnsignedInteger:0], nil] animated:YES];
    }
}

- (void)didInputIndexes:(NSArray<NSNumber *> *)indexes
{
    if (indexes.count == 2)
    {
        _fromAge = [[indexes objectAtIndex:0] unsignedIntegerValue] + 15;
        
        _toAge = [[indexes objectAtIndex:1] unsignedIntegerValue] + _fromAge;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldInputDidUpdateInput:)])
        {
            [self.delegate textFieldInputDidUpdateInput:self];
        }
    }
    else
    {
        
    }
    
    self.textField.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)_fromAge, (unsigned long)_toAge];
}

@end
