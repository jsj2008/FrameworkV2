//
//  UFDataPickerSource.m
//  Test
//
//  Created by ww on 16/3/7.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFDataPickerSource.h"

@implementation UFDataPickerSource

- (NSInteger)numberOfComponents
{
    return 0;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

- (NSArray<NSString *> *)titlesAtIndexes:(NSArray<NSNumber *> *)indexes
{
    return nil;
}

- (NSArray<NSNumber *> *)indexesForTitles:(NSArray<NSString *> *)titles
{
    return nil;
}

@end


@implementation UFDataPickerDictionarySource

- (NSInteger)numberOfComponents
{
    return self.componentsNumber;
}

- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number = 0;
    
    NSDictionary *data = self.data;
    
    for (int i = 0; i <= component; i ++)
    {
        NSInteger index = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickerSource:selectedRowInComponent:)])
        {
            index = [self.delegate dataPickerSource:self selectedRowInComponent:i];
        }
                
        NSArray *array = [[data allValues] firstObject];
        
        number = array.count;
        
        if (number > 0)
        {
            if (index > number - 1)
            {
                index = number - 1;
            }
            
            id object = [array objectAtIndex:index];
            
            if ([object isKindOfClass:[NSDictionary class]])
            {
                data = object;
            }
            else
            {
                data = nil;
                
                break;
            }
        }
    }
    
    return number;
}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    
    NSDictionary *data = self.data;
    
    for (int i = 0; i < component; i ++)
    {
        NSInteger index = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickerSource:selectedRowInComponent:)])
        {
            index = [self.delegate dataPickerSource:self selectedRowInComponent:i];
        }
        
        NSArray *array = [[data allValues] firstObject];
        
        if ([array count] > 0)
        {
            id object = [array objectAtIndex:index];
            
            if ([object isKindOfClass:[NSDictionary class]])
            {
                data = object;
            }
            else
            {
                data = nil;
                
                break;
            }
        }
    }
    
    NSArray *array = [[data allValues] firstObject];
    
    if ([array count] > row)
    {
        id object = [array objectAtIndex:row];
        
        if ([object isKindOfClass:[NSString class]])
        {
            title = object;
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
            title = [[(NSDictionary *)object allKeys] firstObject];
        }
    }
    
    return title;
}

- (NSArray<NSString *> *)titlesAtIndexes:(NSArray<NSNumber *> *)indexes
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    NSDictionary *data = self.data;
    
    for (int i = 0; i < indexes.count; i ++)
    {
        NSInteger index = [[indexes objectAtIndex:i] integerValue];
        
        NSArray *array = [[data allValues] firstObject];
        
        if (array.count > index)
        {
            id object = [array objectAtIndex:index];
            
            if ([object isKindOfClass:[NSString class]])
            {
                [titles addObject:object];
                
                break;
            }
            else if ([object isKindOfClass:[NSDictionary class]])
            {
                [titles addObject:[[(NSDictionary *)object allKeys] firstObject]];
                
                data = object;
            }
            else
            {
                break;
            }
        }
    }
    
    return titles;
}

- (NSArray<NSNumber *> *)indexesForTitles:(NSArray<NSString *> *)titles
{
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    
    NSDictionary *data = self.data;
    
    for (int i = 0; i < titles.count; i ++)
    {
        NSString *title = [titles objectAtIndex:i];
        
        NSArray *array = [[data allValues] firstObject];
        
        BOOL end = NO;
        
        NSInteger index = NSNotFound;
        
        for (int j = 0; j < array.count; j ++)
        {
            id object = [array objectAtIndex:j];
            
            if ([object isKindOfClass:[NSString class]] && [(NSString *)object isEqualToString:title])
            {
                index = j;
                
                end = YES;
                
                break;
            }
            else if ([object isKindOfClass:[NSDictionary class]])
            {
                NSString *key = [[(NSDictionary *)object allKeys] firstObject];
                
                if ([key isEqualToString:title])
                {
                    index = j;
                    
                    data = object;
                    
                    break;
                }
            }
        }
        
        if (index != NSNotFound)
        {
            [indexes addObject:[NSNumber numberWithInteger:index]];
        }
        else
        {
            indexes = nil;
            
            break;
        }
        
        if (end)
        {
            break;
        }
    }
    
    return indexes;
}

@end
