//
//  HTTPMessageBodySerializer.h
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageSerializer.h"

/******************************************************
 
    @class
        HTTPMessageBodySerializer
 
    @abstract
        HTTP报文主体序列化器
 
    @discussion
        HTTPMessageBodySerializer是抽象类，需由子类实现具体功能
 
 ******************************************************/

@interface HTTPMessageBodySerializer : HTTPMessageSerializer

/*!
 * @brief 初始化
 * @param dataStream 数据流
 * @result 初始化后的对象
 */
- (instancetype)initWithDataStream:(NSInputStream *)dataStream;

@end


/******************************************************
 
    @class
        HTTPMessageLengthFixedBodySerializer
 
    @abstract
        定长的HTTP报文主体序列化器
 
 ******************************************************/

@interface HTTPMessageLengthFixedBodySerializer : HTTPMessageBodySerializer

@end


/******************************************************
 
    @class
        HTTPMessageChunkedBodySerializer
 
    @abstract
        chunked传输的HTTP报文主体序列化器
 
 ******************************************************/

@interface HTTPMessageChunkedBodySerializer : HTTPMessageBodySerializer

@end


// 默认的Chunk块长度，4K
extern NSUInteger const HTTPMessageBodyChunkDefaultSerializeLength;
