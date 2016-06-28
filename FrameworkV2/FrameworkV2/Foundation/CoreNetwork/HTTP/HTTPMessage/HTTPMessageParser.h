//
//  HTTPMessageParser.h
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @enum
        HTTPMessageParseStatus
 
    @abstract
        HTTP报文解析状态
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, HTTPMessageParseStatus)
{
    // 解析中
    HTTPMessageParsing = 1,
    
    // 解析结束
    HTTPMessageParseCompleted = 2,
    
    // 解析错误
    HTTPMessageParseError = 3
};


/******************************************************
 
    @class
        HTTPMessageParser
 
    @abstract
        HTTP报文解析器
 
    @discussion
        1，HTTPMessageParser是一个抽象类，需要子类来完成具体功能
 
 ******************************************************/

@interface HTTPMessageParser : NSObject

/*!
 * @brief 解析状态
 */
@property (nonatomic) HTTPMessageParseStatus status;

/*!
 * @brief 错误码
 */
@property (nonatomic) NSError *error;

/*!
 * @brief 缓冲数据
 */
@property (nonatomic, readonly) NSMutableData *buffer;

/*!
 * @brief 添加数据并解析
 * @param data 原始数据
 */
- (void)addData:(NSData *)data;

/*!
 * @brief 未解析的原始数据，在解析结束后可获取
 * @result 未解析的原始数据
 */
- (NSData *)unparsedData;

/*!
 * @brief 清理未解析的原始数据
 */
- (void)cleanUnparsedData;

@end
