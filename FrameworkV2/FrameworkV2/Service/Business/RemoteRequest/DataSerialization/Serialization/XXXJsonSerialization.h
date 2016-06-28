//
//  XXXJsonSerialization.h
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerialize.h"

/*********************************************************
 
    @protocol
        XXXJsonParsing
 
    @abstract
        XXX Json解析协议
 
    @discussion
        协议需提供init和object两个方法，init方法
 
 *********************************************************/

@protocol XXXJsonParsing <NSObject>

/*!
 * @brief 初始化
 * @param jsonNode json根节点（通常为字典形式）
 * @param context 上下文，用于承载解析过程中的参数
 * @result 初始化对象
 */
- (instancetype)initWithXXXJsonNode:(NSDictionary *)jsonNode context:(NSDictionary *)context;

/*!
 * @brief 生成对象
 * @param jsonNode json根节点
 * @param context 上下文，用于承载解析过程中的参数
 * @result 对象
 */
+ (instancetype)objectWithXXXJsonNode:(NSDictionary *)jsonNode context:(NSDictionary *)context;

@end


/*********************************************************
 
    @protocol
        XXXJsonSerialization
 
    @abstract
        XXX Json序列化协议
 
 *********************************************************/

@protocol XXXJsonSerialization <NSObject>

/*!
 * @brief 生成字典根节点
 * @param context 上下文，用于承载序列化过程中的参数
 * @result 字典根节点
 */
- (NSDictionary *)jsonNodeWithContext:(NSDictionary *)context;

@end
