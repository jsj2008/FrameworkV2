//
//  HTTPServerError.m
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPServerError.h"

NSString * const HTTPServerErrorDomain = @"HTTPServerError";


@implementation NSError (HTTPServer)

+ (NSError *)HTTPServerErrorWithCode:(HTTPServerErrorCode)code underlyingError:(NSError *)underlyingError
{
    NSString *description = nil;
    
    switch (code)
    {
        case HTTPServerErrorConnectionInputError:
            
            description = @"connect input error";
            
            break;
            
        case HTTPServerErrorConnectionOutputError:
            
            description = @"connect output error";
            
            break;
            
        case HTTPServerErrorCannotParseRequestMessage:
            
            description = @"connot parse request message";
            
            break;
            
        case HTTPServerErrorCannotSerializeResponseMessage:
            
            description = @"cannot serialize response message";
            
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *infos = [[NSMutableDictionary alloc] init];
    
    if (description)
    {
        [infos setObject:description forKey:NSLocalizedDescriptionKey];
    }
    
    if (underlyingError)
    {
        [infos setObject:underlyingError forKey:NSUnderlyingErrorKey];
    }
    
    return [NSError errorWithDomain:HTTPServerErrorDomain code:code userInfo:(infos.count > 0 ? infos : nil)];
}

@end
