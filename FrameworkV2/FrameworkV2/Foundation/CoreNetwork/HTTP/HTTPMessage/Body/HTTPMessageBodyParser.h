//
//  HTTPMessageBodyParser.h
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageParser.h"

/******************************************************
 
    @class
        HTTPMessageBodyParser
 
    @abstract
        HTTP报文主体解析器
 
    @discussion
        HTTPMessageBodyParser是抽象类，需由子类实现具体功能
 
 ******************************************************/

@interface HTTPMessageBodyParser : HTTPMessageParser

/*!
 * @brief 解析得到的数据块
 */
@property (nonatomic, readonly) NSMutableData *parsedBodyData;

@end


/******************************************************
 
    @class
        HTTPMessageLengthFixedBodyParser
 
    @abstract
        定长的HTTP报文主体解析器
 
 ******************************************************/

@interface HTTPMessageLengthFixedBodyParser : HTTPMessageBodyParser

/*!
 * @brief 初始化
 * @param length 主体长度
 * @result 初始化后的对象
 */
- (instancetype)initWithLength:(unsigned long long)length;

/*!
 * @brief 主体长度
 */
@property (nonatomic, readonly) unsigned long long length;

@end


/******************************************************
 
    @class
        HTTPMessageChunkedBodyParser
 
    @abstract
        chunked传输的HTTP报文主体解析器
 
 ******************************************************/

@interface HTTPMessageChunkedBodyParser : HTTPMessageBodyParser

@end


/******************************************************
 
    @class
        HTTPMessageBodyChunkParser
 
    @abstract
        HTTP报文chunkded主体块解析器
 
 ******************************************************/

@interface HTTPMessageBodyChunkParser : HTTPMessageParser

/*!
 * @brief 解析到的数据
 */
@property (nonatomic) NSMutableData *parsedData;

/*!
 * @brief 是否最后一个chunk
 * @result 是否最后一个chunk
 */
- (BOOL)isEndChunk;

@end
