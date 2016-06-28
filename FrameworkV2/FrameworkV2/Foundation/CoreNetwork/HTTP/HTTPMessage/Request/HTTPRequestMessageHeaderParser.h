//
//  HTTPRequestMessageHeaderParser.h
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageParser.h"
#import "HTTPRequestHeader.h"

/******************************************************
 
    @class
        HTTPRequestMessageHeaderParser
 
    @abstract
        HTTP请求报文头部解析器
 
 ******************************************************/

@interface HTTPRequestMessageHeaderParser : HTTPMessageParser

/*!
 * @brief 解析到的请求头
 */
@property (nonatomic) HTTPRequestHeader *parsedRequestHeader;

@end


// 允许解析的最长请求头部长度，超过该长度后将会认为解析失败，10K
extern NSUInteger const HTTPRequestMessageHeaderMaxParseLength;
