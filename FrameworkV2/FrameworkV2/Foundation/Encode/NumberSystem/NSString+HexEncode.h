//
//  NSString+HexEncode.h
//  FrameworkV2
//
//  Created by ww on 22/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSString (HexEncode)
 
    @abstract
        NSString的十六进制编解码扩展
 
 *********************************************************/

@interface NSString (HexEncode)

/*!
 * @brief 十六进制编码
 * @discussion 将字节数据按其十六进制值转换成字符串，如字节数据12abcd转换成字符串"12abcd"
 * @param data 原始字节数据
 * @result 编码后的字符串
 */
+ (NSString *)stringByAddingHexEncodingWithData:(NSData *)data;

/*!
 * @brief 十六进制解码
 * @discussion 将字符串按照其字面十六进制值转换成对应十六进制值的字节数据，如字符串"12abcd"转换成字节数据12abcd
 * @discussion 字符串本身务必保证只包含字符0123456789abcdef，且长度必须为偶数
 * @result 解码后的字节数据
 */
- (NSData *)dataByRemovingHexEncoding;

@end
