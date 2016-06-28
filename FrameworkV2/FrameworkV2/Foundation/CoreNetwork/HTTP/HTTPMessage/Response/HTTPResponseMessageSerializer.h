//
//  HTTPResponseMessageSerializer.h
//  HS
//
//  Created by ww on 16/5/23.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageSerializer.h"
#import "HTTPResponseHeader.h"

/******************************************************
 
    @class
        HTTPResponseMessageSerializer
 
    @abstract
        HTTP响应报文序列化器
 
 ******************************************************/

@interface HTTPResponseMessageSerializer : HTTPMessageSerializer

/*!
 * @brief 初始化
 * @param responseHeader 响应头
 * @result 初始化后的对象
 */
- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader;

/*!
 * @brief 初始化
 * @param responseHeader 响应头
 * @param bodyData 报文主体数据
 * @result 初始化后的对象
 */
- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader bodyData:(NSData *)bodyData;

/*!
 * @brief 初始化
 * @param responseHeader 响应头
 * @param bodyStream 报文主体数据流
 * @result 初始化后的对象
 */
- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader bodyStream:(NSInputStream *)bodyStream;

/*!
 * @brief 报文主体长度
 * @param -1表征无法获取主体长度，当报文主体是流时会出现该情况
 */
@property (nonatomic, readonly) long long bodySize;

/*!
 * @brief 已读取的报文主体长度
 */
@property (nonatomic, readonly) unsigned long long consumedBodySize;

/*!
 * @brief 上一次读取的报文主体长度
 */
@property (nonatomic, readonly) unsigned long long consumedBodySizeInLastRead;

@end
