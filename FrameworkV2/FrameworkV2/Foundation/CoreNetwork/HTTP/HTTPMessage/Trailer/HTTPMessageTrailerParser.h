//
//  HTTPMessageTrailerParser.h
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageParser.h"
#import "HTTPTrailer.h"

/******************************************************
 
    @class
        HTTPMessageTrailerParser
 
    @abstract
        HTTP报文拖挂解析器
 
 ******************************************************/

@interface HTTPMessageTrailerParser : HTTPMessageParser

/*!
 * @brief 初始化
 * @param headerFieldNames 拖挂包括的首部
 * @result 初始化后的对象
 */
- (instancetype)initWithHeaderFieldNames:(NSArray<NSString *> *)headerFieldNames;

/*!
 * @brief 拖挂包括的首部
 */
@property (nonatomic, readonly, copy) NSArray<NSString *> *headerFieldNames;

/*!
 * @brief 解析到的拖挂
 */
@property (nonatomic) HTTPTrailer *parsedTrailer;

@end


// 允许解析的最长拖挂长度，超过该长度后将会认为解析失败，10K
extern NSUInteger const HTTPMessageTrailerMaxParseLength;
