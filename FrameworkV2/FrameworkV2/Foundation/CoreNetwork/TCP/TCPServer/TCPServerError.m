//
//  TCPServerError.m
//  HS
//
//  Created by ww on 16/6/2.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "TCPServerError.h"

NSString * const TCPServerErrorDomain = @"TCPServerError";


@implementation NSError (TCPServer)

+ (NSError *)TCPServerErrorWithCode:(TCPServerErrorCode)code
{
    NSString *description = nil;
    
    switch (code)
    {
        case TCPServerErrorIPv4SocketError:
            
            description = @"IPv4 socket create fail";
            
            break;
            
        case TCPServerErrorIPv6SocketError:
            
            description = @"IPv6 socket create fail";
            
            break;
            
        default:
            break;
    }
    
    return [NSError errorWithDomain:TCPServerErrorDomain code:code userInfo:description ? [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey] : nil];
}

@end
