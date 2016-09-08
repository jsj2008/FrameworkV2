//
//  XXXRequestError.m
//  FrameworkV2
//
//  Created by ww on 16/7/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "XXXRequestError.h"

NSString * const XXXRequestErrorDomain = @"XXXRequest";


@implementation NSError (XXXRequest)

+ (NSError *)XXXRequestErrorWithCode:(XXXRequestErrorCode)code description:(NSString *)description
{
    return [NSError errorWithDomain:XXXRequestErrorDomain code:code userInfo:description ? [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey] : nil];
}

+ (NSError *)XXXRequestErrorWithCode:(XXXRequestErrorCode)code
{
    NSString *description = nil;
    
    switch (code)
    {
        case XXXRequestErrorInvalidDataNode:
            
            description = @"非法data节点";
            
            break;
            
        default:
            break;
    }
    
    return [NSError XXXRequestErrorWithCode:code description:description];
}

@end
