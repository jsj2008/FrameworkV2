//
//  HTTPServerError.h
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

// HTTP服务器错误域
extern NSString * const HTTPServerErrorDomain;


/******************************************************
 
    @enum
        HTTPServerErrorCode
 
    @abstract
        HTTP服务器错误码
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, HTTPServerErrorCode)
{
    // 连接输入错误
    HTTPServerErrorConnectionInputError = 1,
    
    // 连接输出错误
    HTTPServerErrorConnectionOutputError = 2,
    
    // 无法解析请求报文
    HTTPServerErrorCannotParseRequestMessage = 3,
    
    // 无法序列化响应报文
    HTTPServerErrorCannotSerializeResponseMessage = 4,
};


/******************************************************
 
    @category
        NSError (HTTPServer)
 
    @abstract
        错误对象的HTTP服务器扩展
 
 ******************************************************/

@interface NSError (HTTPServer)

/*!
 * @brief HTTP服务器错误对象
 * @param code 错误码
 * @param underlyingError 底层错误原因
 * @result HTTP服务器错误对象
 */
+ (NSError *)HTTPServerErrorWithCode:(HTTPServerErrorCode)code underlyingError:(NSError *)underlyingError;

@end
