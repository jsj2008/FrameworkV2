//
//  NSData+MD5.h
//  FrameworkV1
//
//  Created by ww on 16/4/21.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSData (MD5)
 
    @abstract
        NSData的类别扩展，实现MD5编码
 
 *********************************************************/

@interface NSData (MD5)

/*!
 * @brief MD5编码字符串并大写
 * @result 编码后字符串
 */
- (NSString *)stringByAddingMD5Encoding;

@end
