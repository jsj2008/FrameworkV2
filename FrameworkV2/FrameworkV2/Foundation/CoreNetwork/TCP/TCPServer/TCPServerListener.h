//
//  TCPServerListener.h
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPServerConnection.h"

@protocol TCPServerListenerDelegate;

/******************************************************
 
    @class
        TCPServerListener
 
    @abstract
        TCP端口监听对象
 
 ******************************************************/

@interface TCPServerListener : NSObject

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<TCPServerListenerDelegate>delegate;

/*!
 * @brief 初始化
 * @param port 服务端监听端口
 * @result 初始化后的对象
 */
- (id)initWithPort:(NSInteger)port;

/*!
 * @brief 当前IPv4端口
 */
@property (nonatomic, readonly) NSInteger currentIPv4Port;

/*!
 * @brief 当前IPv6端口
 */
@property (nonatomic, readonly) NSInteger currentIPv6Port;

/*!
 * @brief 错误
 */
@property (nonatomic, readonly) NSError *error;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 取消
 */
- (void)cancel;

@end

/******************************************************
 
    @protocol
        TCPServerListenerDelegate
 
    @abstract
        TCP监听的协议消息
 
 ******************************************************/

@protocol TCPServerListenerDelegate <NSObject>

/*!
 * @brief 监听到端口连接
 * @param listener 监听对象
 * @param connection TCP连接
 */
- (void)TCPServerListener:(TCPServerListener *)listener didAcceptConnection:(TCPServerConnection *)connection;

@end
