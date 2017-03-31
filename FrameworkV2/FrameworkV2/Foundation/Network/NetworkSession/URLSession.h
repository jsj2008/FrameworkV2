//
//  URLSession.h
//  FrameworkV2
//
//  Created by ww on 2017/3/31.
//  Copyright © 2017年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class URLSessionCredential;

@protocol URLSessionDelegate;


/*********************************************************
 
    @class
        URLSession
 
    @abstract
        网络会话，是对NSURLSession的封装，内部承接NSURLSession的delegate通知
 
 *********************************************************/

@interface URLSession : NSObject

/*!
 * @brief 初始化
 * @param configuration 会话配置信息
 * @result 初始化后的对象
 */
- (instancetype)initWithURLSessionConfiguration:(NSURLSessionConfiguration *)configuration;

/*!
 * @brief 会话对象
 */
@property (nonatomic, readonly) NSURLSession *session;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<URLSessionDelegate> delegate;

/*!
 * @brief 认证证书对象
 * @discussion 会话证书只处理HTTPs，客户端SSL和TLS，NTLM和Negotiate四种类型的认证信息，其他类型的认证交由各个具体的连接处理
 * @discussion 若未指定证书，将采用默认方式处理：
        HTTPs：信任所有的服务器证书，直接通过认证；
        客户端SSL和TLS：拒绝认证，直接进行下一项认证；
        NTLM：拒绝认证，直接进行下一项认证；
        Negotiate：拒绝认证，直接进行下一项认证
 * @discussion 证书对象的操作可能在子线程中执行
 */
@property (nonatomic) URLSessionCredential *credential;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 取消
 * @discussion 取消后不再发送delegate通知
 */
- (void)cancel;

@end


/*********************************************************
 
    @protocol
        URLSessionDelegate
 
    @abstract
        网络会话的delegate通知
 
 *********************************************************/

@protocol URLSessionDelegate <NSObject>

/*!
 * @brief 会话结束
 * @param session 会话对象
 * @param error 错误信息
 */
- (void)URLSession:(URLSession *)session didBecomeInvalidWithError:(NSError *)error;

/*!
 * @brief 会话完成后台工作
 * @param session 会话对象
 */
- (void)URLSessionDidFinishEventsForBackgroundSession:(URLSession *)session;

@end


/*********************************************************
 
    @class
        URLSessionCredential
 
    @abstract
        网络会话证书
 
    @discussion
        会话证书只处理HTTPs，客户端SSL和TLS，NTLM和Negotiate四种类型的认证信息
 
 *********************************************************/

@interface URLSessionCredential : NSObject

/*!
 * @brief 特定的认证挑战的证书
 * @param challenge 挑战
 * @result 证书，若为nil，表征拒绝认证
 */
- (NSURLCredential *)credentialForChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
