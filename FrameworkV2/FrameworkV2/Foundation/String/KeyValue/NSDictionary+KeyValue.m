//
//  NSDictionary+KeyValue.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSDictionary+KeyValue.h"

@implementation NSDictionary (KeyValue)

- (NSString *)keyValuedStringByKeyValueDelimiter:(NSString *)keyValueDelimiter componentDelimiter:(NSString *)componentDelimiter
{
    NSMutableString *string = nil;
    
    NSUInteger count = [self count];
    
    if (count)
    {
        string = [NSMutableString string];
        
        NSArray *keys = [self allKeys];
        
        for (int i = 0; i < count; i ++)
        {
            NSString *key = [keys objectAtIndex:i];
            
            NSString *value = [self objectForKey:key];
            
            if ([value isEqualToString:@""])
            {
                if (i)
                {
                    [string appendFormat:@"%@%@", componentDelimiter, key];
                }
                else
                {
                    [string appendString:key];
                }
            }
            else
            {
                if (i)
                {
                    [string appendFormat:@"%@%@%@%@", componentDelimiter, key, keyValueDelimiter, value];
                }
                else
                {
                    [string appendFormat:@"%@%@%@", key, keyValueDelimiter, value];
                }
            }
        }
    }
    
    return [string length] ? string : nil;
}

@end
