//
//  NSString+KeyValue.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSString (KeyValue)
 
    @abstract
        NSString的键值要素扩展，封装字符串与字典间的转换
 
 *********************************************************/

@interface NSString (KeyValue)

/*!
 * @brief 将字符串转换成字典
 * @discussion 字符串按照分隔符拆分成多个键值对字符串，每个键值对字符串通过键值分隔符拆分成键和值，值可以为空字符串；若键值对字符串不含键值分隔符，则将键值对字符串作为键，将空字符串作为值
 * @discussion 如“a=3&b=4=5”，键值分隔符为“＝”，字符串分隔符为“&”，转换结果为{(a,3),(b,4=5)}
 * @param keyValueDelimiter 键值分隔符
 * @param componentDelimiter 字符串分隔符
 * @result 字典
 */
- (NSDictionary<NSString *, NSString *> *)keyValuedComponentsByKeyValueDelimiter:(NSString *)keyValueDelimiter componentDelimiter:(NSString *)componentDelimiter;

@end
