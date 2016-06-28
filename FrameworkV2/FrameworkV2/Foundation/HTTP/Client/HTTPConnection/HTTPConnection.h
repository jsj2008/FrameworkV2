//
//  HTTPConnection.h
//  Test1
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPSession.h"
#import "NSURLSessionTask+Delegate.h"

@class HTTPConnectionInternetPassword;


/*********************************************************
 
    @class
        HTTPConnection
 
    @abstract
        HTTP连接，用于处理具体的HTTP请求
 
    @discussion
        1，HTTPConnection是一个抽象类，具体功能需子类实现
        2，HTTPConnection默认实现了重定向：按照响应首部指定的地址重定向
        3，HTTPConnection默认实现了认证处理：使用指定的账户密码认证，认证失败直接进行下一项认证
 
 *********************************************************/

@interface HTTPConnection : NSObject <URLSessionTaskDelegate>

/*!
 * @brief 初始化
 * @param request 请求信息
 * @param session 会话信息
 * @result 初始化后的对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request session:(HTTPSession *)session;

/*!
 * @brief 原始请求
 */
@property (nonatomic, readonly, copy) NSURLRequest *originalRequest;

/*!
 * @brief 当前请求
 */
@property (nonatomic, readonly, copy) NSURLRequest *currentRequest;

/*!
 * @brief 会话对象
 */
@property (nonatomic, readonly) HTTPSession *session;

/*!
 * @brief 认证账户
 */
@property (nonatomic) HTTPConnectionInternetPassword *internetPassword;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 取消
 */
- (void)cancel;

@end


/*********************************************************
 
    @class
        HTTPConnectionInternetPassword
 
    @abstract
        HTTP认证账户
 
 *********************************************************/

@interface HTTPConnectionInternetPassword : NSObject

/*!
 * @brief 用户名
 */
@property (nonatomic, copy) NSString *user;

/*!
 * @brief 密码
 */
@property (nonatomic, copy) NSString *password;

@end
