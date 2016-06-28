//
//  HTTPServerConnection.h
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPServerConnection.h"
#import "HTTPRequestHeader.h"
#import "HTTPResponseHeader.h"
#import "HTTPTrailer.h"

@protocol HTTPServerConnectionDelegate;


/******************************************************
 
    @class
        HTTPServerConnection
 
    @abstract
        HTTP服务器连接
 
    @discussion
        连接只能启动和取消一次
 
 ******************************************************/

@interface HTTPServerConnection : NSObject

/*!
 * @brief 初始化
 * @param TCPConnection TCP连接
 * @result 初始化后的对象
 */
- (instancetype)initWithTCPServerConnection:(TCPServerConnection *)TCPConnection;

/*!
 * @brief TCP连接
 */
@property (nonatomic, readonly) TCPServerConnection *TCPConnection;

/*!
 * @brief 消息代理
 */
@property (nonatomic, weak) id<HTTPServerConnectionDelegate> delegate;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 取消
 */
- (void)cancel;

/*!
 * @brief 关闭接收
 */
- (void)closeReceiving;

/*!
 * @brief 关闭发送
 */
- (void)closeSending;

/*!
 * @brief 发送响应报文
 * @param response 响应头
 */
- (void)sendResponse:(HTTPResponseHeader *)response;

/*!
 * @brief 发送响应报文
 * @param response 响应头
 * @param bodyData 消息体
 */
- (void)sendResponse:(HTTPResponseHeader *)response bodyData:(NSData *)bodyData;

/*!
 * @brief 发送响应报文
 * @param response 响应头
 * @param bodyStream 流式消息体
 */
- (void)sendResponse:(HTTPResponseHeader *)response bodyStream:(NSInputStream *)bodyStream;

@end


/******************************************************
 
    @protocol
        HTTPServerConnectionDelegate
 
    @abstract
        HTTP服务器连接的消息协议
 
 ******************************************************/

@protocol HTTPServerConnectionDelegate <NSObject>

/*!
 * @brief 连接结束
 * @param connection 连接
 * @param error 错误
 */
- (void)HTTPServerConnection:(HTTPServerConnection *)connection didFinishWithError:(NSError *)error;

/*!
 * @brief 接收到请求头
 * @param connection 连接
 * @param request 请求头
 */
- (void)HTTPServerConnection:(HTTPServerConnection *)connection didReceiveRequest:(HTTPRequestHeader *)request;

/*!
 * @brief 接收到请求报文主体数据
 * @param connection 连接
 * @param data 报文主体数据
 */
- (void)HTTPServerConnection:(HTTPServerConnection *)connection didReceiveData:(NSData *)data;

/*!
 * @brief 接收到请求报文拖挂
 * @param connection 连接
 * @param trailer 报文拖挂
 */
- (void)HTTPServerConnection:(HTTPServerConnection *)connection didReceiveTrailer:(HTTPTrailer *)trailer;

/*!
 * @brief 结束接收数据
 * @param connection 连接
 * @param error 错误
 */
- (void)HTTPServerConnection:(HTTPServerConnection *)connection didFinishReceiveDataWithError:(NSError *)error;

/*!
 * @brief 发送数据
 * @param connection 连接
 * @param bytesWritten 距离上一下发送时间间隔内的发送量
 * @param totalBytesWritten 已发送总量
 * @param totalBytesExpectedToWrite 预期发送总量，－1表征无法获取（chunked传输下会出现此情况）
 */
- (void)HTTPServerConnection:(HTTPServerConnection *)connection didSendData:(unsigned long long)bytesWritten totalBytesWritten:(unsigned long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;

/*!
 * @brief 结束发送数据
 * @param connection 连接
 * @param error 错误
 */
- (void)HTTPServerConnection:(HTTPServerConnection *)connection didFinishSendDataWithError:(NSError *)error;

@end
