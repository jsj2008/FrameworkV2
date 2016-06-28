//
//  HTTPMessageSerializer.h
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @enum
        HTTPMessageSerializerStatus
 
    @abstract
        HTTP报文序列化状态
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, HTTPMessageSerializerStatus)
{
    // 序列化中
    HTTPMessageSerializing = 1,
    
    // 序列化结束
    HTTPMessageSerializeCompleted = 2,
    
    // 序列化错误
    HTTPMessageSerializeError = 3
};


/******************************************************
 
    @class
        HTTPMessageSerializer
 
    @abstract
        HTTP报文序列化器
 
    @discussion
        1，HTTPMessageSerializer是一个抽象类，需要子类来完成具体功能
 
 ******************************************************/

@interface HTTPMessageSerializer : NSObject

/*!
 * @brief 序列化状态
 */
@property (nonatomic) HTTPMessageSerializerStatus status;

/*!
 * @brief 错误码
 */
@property (nonatomic) NSError *error;

/*!
 * @brief 读取序列化数据并移除这部分数据
 * @param maxLength 数据最大长度
 * @result 序列化数据
 */
- (NSData *)dataWithMaxLength:(NSUInteger)maxLength;

@end
