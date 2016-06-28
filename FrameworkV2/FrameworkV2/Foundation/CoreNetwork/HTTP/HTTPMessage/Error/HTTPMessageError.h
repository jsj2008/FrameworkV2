//
//  HTTPMessageError.h
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

// HTTP报文错误域
extern NSString * const HTTPMessageErrorDomain;


/******************************************************
 
    @enum
        HTTPMessageErrorCode
 
    @abstract
        HTTP报文错误码
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, HTTPMessageErrorCode)
{
    // 未知请求头（不符合HTTP标准）
    HTTPMessageErrorUnknownRequestHeader = 1,
    
    // 超过允许的请求头最大长度仍未解析出请求头
    HTTPMessageErrorRequestHeaderExceedLength = 2,
    
    // 未知消息体大小（未能正确解析chunked消息体）
    HTTPMessageErrorUnknownBodySize = 3,
    
    // 未知拖挂
    HTTPMessageErrorUnknownTrailer = 4,
    
    // 超过允许的拖挂最大长度仍未解析出拖挂
    HTTPMessageErrorTrailerExceedLength = 5
};


/******************************************************
 
    @category
        NSError (HTTPMessage)
 
    @abstract
        错误对象的HTTP报文扩展
 
 ******************************************************/

@interface NSError (HTTPMessage)

/*!
 * @brief HTTP报文错误对象
 * @param code 错误码
 * @param description 错误描述
 * @result HTTP报文错误对象
 */
+ (NSError *)HTTPMessageErrorWithCode:(HTTPMessageErrorCode)code description:(NSString *)description;

/*!
 * @brief HTTP报文错误对象
 * @param code 错误码
 * @result HTTP报文错误对象
 */
+ (NSError *)HTTPMessageErrorWithCode:(HTTPMessageErrorCode)code;

@end
