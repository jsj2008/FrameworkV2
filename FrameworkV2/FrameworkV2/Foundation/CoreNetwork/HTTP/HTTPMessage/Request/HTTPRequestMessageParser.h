//
//  HTTPRequestMessageParser.h
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageParser.h"
#import "HTTPRequestHeader.h"
#import "HTTPTrailer.h"

@class HTTPRequestMessageParsedChunk;


/******************************************************
 
    @class
        HTTPRequestMessageParser
 
    @abstract
        HTTP请求报文解析器
 
 ******************************************************/

@interface HTTPRequestMessageParser : HTTPMessageParser

/*!
 * @brief 解析得到的数据块
 */
@property (nonatomic, readonly) NSMutableArray<HTTPRequestMessageParsedChunk *> *parsedChunks;

@end


/******************************************************
 
    @class
        HTTPRequestMessageParsedChunk
 
    @abstract
        HTTP请求报文解析数据块
 
 ******************************************************/

@interface HTTPRequestMessageParsedChunk : NSObject

@end


/******************************************************
 
    @class
        HTTPRequestMessageParsedHeaderChunk
 
    @abstract
        HTTP请求报文解析头部数据块
 
 ******************************************************/

@interface HTTPRequestMessageParsedHeaderChunk : HTTPRequestMessageParsedChunk

/*!
 * @brief 请求头
 */
@property (nonatomic) HTTPRequestHeader *requestHeader;

@end


/******************************************************
 
    @class
        HTTPRequestMessageParsedBodyDataChunk
 
    @abstract
        HTTP请求报文解析报文主体数据块
 
 ******************************************************/

@interface HTTPRequestMessageParsedBodyDataChunk : HTTPRequestMessageParsedChunk

/*!
 * @brief 报文主体
 */
@property (nonatomic) NSData *bodyData;

@end


/******************************************************
 
    @class
        HTTPRequestMessageParsedTrailerChunk
 
    @abstract
        HTTP请求报文解析报拖挂数据块
 
 ******************************************************/

@interface HTTPRequestMessageParsedTrailerChunk : HTTPRequestMessageParsedChunk

/*!
 * @brief 拖挂
 */
@property (nonatomic) HTTPTrailer *trailer;

@end
