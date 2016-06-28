//
//  NSDictionary+KeyValue.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        NSDictionary (KeyValue)
 
    @abstract
        NSDictionary的键值要素扩展，封装字典与字符串间的转换
 
 *********************************************************/

@interface NSDictionary (KeyValue)

/*!
 * @brief 将字典转换成字符串
 * @discussion 字典通过键值分隔符连接键和值生成键值对字符串，再通过分隔符拼接键值对字符串，若值为空字符串，则不生成键值分隔符，只保留键字符串
 * @discussion 如{(a,3),(b,4)}，键值分隔符为“＝”，字符串分隔符为“&”，转换结果为“a=3&b=4”；{(a,3),(b,)}，分隔符为“&”，转换结果为“a=3&b”
 * @param keyValueDelimiter 键值分隔符
 * @param componentDelimiter 字符串分隔符
 * @result 字符串
 */
- (NSString *)keyValuedStringByKeyValueDelimiter:(NSString *)keyValueDelimiter componentDelimiter:(NSString *)componentDelimiter;

@end
