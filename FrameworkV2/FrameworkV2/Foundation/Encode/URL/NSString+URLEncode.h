//
//  NSString+URLEncode.h
//  Test1
//
//  Created by ww on 16/4/15.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSString (URLEncode)
 
    @abstract
        字符串的URL编码扩展
 
    @discussion
        根据URL规则对字符串进行百分号数据转换
 
 *********************************************************/

@interface NSString (URLEncode)

/*!
 * @brief 字符串URL数据格式编码
 * @result 编码后的字符串
 */
- (NSString *)stringByAddingURLEncoding;

/*!
 * @brief 字符串URL数据格式解码
 * @result 解码后的字符串
 */
- (NSString *)stringByRemovingURLEncoding;

@end
