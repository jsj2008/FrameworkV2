//
//  HTTPMultipartFormPartContentDisposition.m
//  Test1
//
//  Created by ww on 16/4/14.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPMultipartFormPartContentDisposition.h"
#import "NSString+URLEncode.h"

@implementation HTTPMultipartFormPartContentDisposition

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init])
    {
        NSArray *components = [string componentsSeparatedByString:@";"];
        
        if ([components count] > 1)
        {
            self.type = [components objectAtIndex:0];
            
            NSMutableArray *pairs = [[NSMutableArray alloc] init];
            
            for (int i = 1; i < [components count]; i ++)
            {
                NSString *pairString = [components objectAtIndex:i];
                
                HTTPMultipartFormPartContentDispositionKeyValuePair *keyValuePair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] initWithString:pairString];
                
                if (keyValuePair.key && keyValuePair.value)
                {
                    [pairs addObject:keyValuePair];
                }
            }
            
            if ([pairs count] > 0)
            {
                self.keyValuePairs = pairs;
            }
        }
    }
    
    return self;
}

- (NSString *)string
{
    NSMutableArray *components = [[NSMutableArray alloc] init];
    
    if (self.type)
    {
        [components addObject:self.type];
    }
    
    for (HTTPMultipartFormPartContentDispositionKeyValuePair *pair in self.keyValuePairs)
    {
        NSString *pairString = [pair string];
        
        if (pairString)
        {
            [components addObject:pairString];
        }
    }
    
    return [components count] > 0 ? [components componentsJoinedByString:@";"] : nil;
}

@end


@implementation HTTPMultipartFormPartContentDispositionKeyValuePair

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init])
    {
        NSRange range = [string rangeOfString:@"="];
        
        NSString *key = [string substringToIndex:range.location];
        
        NSString *value = [string substringFromIndex:range.location];
        
        if ([value length] >= 3 && [value hasPrefix:@"=\""] && [value hasSuffix:@"\""])
        {
            value = [value substringWithRange:NSMakeRange(2, [value length] - 3)];
        }
        else
        {
            value = nil;
        }
        
        if (key && value)
        {
            self.key = [key stringByRemovingURLEncoding];
            
            self.value = [value stringByRemovingURLEncoding];
        }
    }
    
    return self;
}

- (NSString *)string
{
    NSString *string = nil;
    
    if (self.key && self.value)
    {
        string = [NSString stringWithFormat:@"%@=\"%@\"", [self.key stringByAddingURLEncoding], [self.value stringByAddingURLEncoding]];
    }
    
    return string;
}

@end
