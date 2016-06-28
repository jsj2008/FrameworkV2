//
//  HTTPUploadConnection.h
//  Test1
//
//  Created by ww on 16/4/11.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnection.h"
#import "HTTPConnectionInputStream.h"

@protocol HTTPUploadConnectionDelegate;


/*********************************************************
 
    @class
        HTTPUploadConnection
 
    @abstract
        HTTP上传连接，用于上传资源到远端
 
    @discussion
        1，HTTPDownloadConnection支持上传文件和数据流
 
 *********************************************************/

@interface HTTPUploadConnection : HTTPConnection

/*!
 * @brief 初始化
 * @param task uploadTask
 * @result 初始化后的对象
 */
- (instancetype)initWithURLSessionUploadTask:(NSURLSessionUploadTask *)task;

/*!
 * @brief 初始化
 * @param request 请求信息
 * @param data 上传数据块
 * @param session 会话信息
 * @result 初始化后的对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request fromData:(NSData *)data session:(HTTPSession *)session;

/*!
 * @brief 初始化
 * @param request 请求信息
 * @param file 上传文件
 * @param session 会话信息
 * @result 初始化后的对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request fromFile:(NSURL *)file session:(HTTPSession *)session;

/*!
 * @brief 初始化
 * @param request 请求信息
 * @param stream 上传数据流
 * @param session 会话信息
 * @result 初始化后的对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request fromStream:(HTTPConnectionInputStream *)stream session:(HTTPSession *)session;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPUploadConnectionDelegate> delegate;

@end


/*********************************************************
 
    @protocol
        HTTPUploadConnectionDelegate
 
    @abstract
        HTTP上传连接的delegate通知
 
 *********************************************************/

@protocol HTTPUploadConnectionDelegate <NSObject>

/*!
 * @brief 请求结束
 * @param uploadConnection 上传连接
 * @param error 错误信息
 * @param response 响应信息
 * @param data 响应数据
 */
- (void)HTTPUploadConnection:(HTTPUploadConnection *)uploadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

@optional

/*!
 * @brief 上传进度通知
 * @param uploadConnection 上传连接
 * @param bytesSent 两次通知间的发送量
 * @param totalBytesSent 已发送总量
 * @param totalBytesExpectedToSend 期望发送总量（资源大小）
 */
- (void)HTTPUploadConnection:(HTTPUploadConnection *)uploadConnection didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

@end
