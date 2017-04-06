//
//  NSData+_3DES.h
//  FrameworkV2
//
//  Created by ww on 22/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

/*********************************************************
 
    @category
        NSData (_3DES)
 
    @abstract
        NSData的3DES编解码扩展
 
 *********************************************************/

@interface NSData (_3DES)

/*!
 * @brief 3DES编解码
 * @discussion 建议采用kCCOptionECBMode | kCCOptionPKCS7Padding方式编解码
 * @param operation 编解码操作
 * @param options 编解码选项
 * @param key 编解码密钥，要求长度为16位
 * @param iv 初始向量，要求长度为16位
 * @result 编解码后的数据
 */
- (NSData *)dataByAdding3DESEncodingByOperation:(CCOperation)operation withOptions:(CCOptions)options key:(NSData *)key iv:(NSData *)iv;

@end
