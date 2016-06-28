//
//  HTTPMessageError.m
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageError.h"

NSString * const HTTPMessageErrorDomain = @"HTTPMessageError";


@implementation NSError (HTTPMessage)

+ (NSError *)HTTPMessageErrorWithCode:(HTTPMessageErrorCode)code description:(NSString *)description
{
    return [NSError errorWithDomain:HTTPMessageErrorDomain code:code userInfo:description ? [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey] : nil];
}

+ (NSError *)HTTPMessageErrorWithCode:(HTTPMessageErrorCode)code
{
    NSString *description = nil;
    
    switch (code)
    {
        case HTTPMessageErrorUnknownRequestHeader:
            
            description = @"unknown request header";
            
            break;
            
        case HTTPMessageErrorRequestHeaderExceedLength:
            
            description = @"request header too large";
            
            break;
            
        case HTTPMessageErrorUnknownBodySize:
            
            description = @"unknown body size";
            
            break;
            
        case HTTPMessageErrorUnknownTrailer:
            
            description = @"unknown trailer";
            
            break;
            
        case HTTPMessageErrorTrailerExceedLength:
            
            description = @"trailer too large";
            
            break;
            
        default:
            break;
    }
    
    return [NSError HTTPMessageErrorWithCode:code description:description];
}

@end
