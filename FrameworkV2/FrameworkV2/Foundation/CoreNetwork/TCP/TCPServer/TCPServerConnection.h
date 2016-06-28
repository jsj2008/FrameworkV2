//
//  TCPServerConnection.h
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @class
        TCPServerConnection
 
    @abstract
        TCP服务端连接
 
 ******************************************************/

@interface TCPServerConnection : NSObject

/*!
 * @brief 初始化
 * @param socketNativeHandle Socket句柄
 * @result 初始化后的对象
 */
- (id)initWithSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle;

/*!
 * @brief Socket句柄
 */
@property (nonatomic, readonly) CFSocketNativeHandle socketNativeHandle;

/*!
 * @brief 客户端地址（如“10.10.10.10”）
 */
@property (nonatomic, copy, readonly) NSString *socketAddress;

/*!
 * @brief 本地数据通讯端口
 */
@property (nonatomic, readonly) NSUInteger socketPort;

/*!
 * @brief 数据接收流
 * @discussion 使用者可以设置流的delegate来获取流的通知
 */
@property (nonatomic, readonly) NSInputStream *receivingStream;

/*!
 * @brief 数据发送流
 * @discussion 使用者可以设置流的delegate来获取流的通知
 */
@property (nonatomic, readonly) NSOutputStream *sendingStream;

@end
