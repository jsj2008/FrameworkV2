//
//  TCPServerError.h
//  HS
//
//  Created by ww on 16/6/2.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

// TCP服务器错误域
extern NSString * const TCPServerErrorDomain;


/******************************************************
 
    @enum
        TCPServerErrorCode
 
    @abstract
        TCP服务器错误码
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, TCPServerErrorCode)
{
    // IPv4 socket错误
    TCPServerErrorIPv4SocketError = 1,
    
    // IPv6 socket错误
    TCPServerErrorIPv6SocketError = 2
};


/******************************************************
 
    @category
        NSError (TCPServer)
 
    @abstract
        错误对象的TCP服务器扩展
 
 ******************************************************/

@interface NSError (TCPServer)

/*!
 * @brief TCP服务器错误对象
 * @param code 错误码
 * @result TCP服务器错误对象
 */
+ (NSError *)TCPServerErrorWithCode:(TCPServerErrorCode)code;

@end
