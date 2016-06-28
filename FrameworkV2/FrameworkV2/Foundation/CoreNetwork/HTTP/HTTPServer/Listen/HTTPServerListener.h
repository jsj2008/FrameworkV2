//
//  HTTPServerListener.h
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPServerConnection.h"

@protocol HTTPServerListenerDelegate;


/******************************************************
 
    @class
        HTTPServerListener
 
    @abstract
        HTTP端口监听对象
 
 ******************************************************/

@interface HTTPServerListener : NSObject

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPServerListenerDelegate>delegate;

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
        HTTPServerListenerDelegate
 
    @abstract
        HTTP监听的协议消息
 
 ******************************************************/

@protocol HTTPServerListenerDelegate <NSObject>

/*!
 * @brief 监听到端口连接
 * @param listener 监听对象
 * @param connection HTTP连接
 */
- (void)HTTPServerListener:(HTTPServerListener *)listener didAcceptConnection:(HTTPServerConnection *)connection;

@end
