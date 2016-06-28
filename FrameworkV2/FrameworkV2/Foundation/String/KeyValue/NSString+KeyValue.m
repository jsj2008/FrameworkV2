//
//  NSString+KeyValue.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSString+KeyValue.h"

@implementation NSString (KeyValue)

- (NSDictionary<NSString *,NSString *> *)keyValuedComponentsByKeyValueDelimiter:(NSString *)keyValueDelimiter componentDelimiter:(NSString *)componentDelimiter
{
    NSMutableDictionary *KVedComponents = nil;
    
    NSArray *stringComponents = [self componentsSeparatedByString:componentDelimiter];
    
    if ([stringComponents count])
    {
        KVedComponents = [NSMutableDictionary dictionary];
        
        for (NSString *stringComponent in stringComponents)
        {
            NSRange range = [stringComponent rangeOfString:keyValueDelimiter];
            
            if (range.location != NSNotFound)
            {
                NSString *key = [stringComponent substringToIndex:range.location];
                
                if (range.location < [stringComponent length] - 1)
                {
                    NSString *value = [stringComponent substringFromIndex:range.location + 1];
                    
                    [KVedComponents setObject:value forKey:key];
                }
                else
                {
                    [KVedComponents setObject:@"" forKey:key];
                }
            }
            else
            {
                [KVedComponents setObject:@"" forKey:stringComponent];
            }
        }
    }
    
    return [KVedComponents count] ? KVedComponents : nil;
}

@end
