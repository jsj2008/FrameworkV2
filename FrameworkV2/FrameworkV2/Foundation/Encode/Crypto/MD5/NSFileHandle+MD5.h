//
//  NSFileHandle+MD5.h
//  FrameworkV1
//
//  Created by ww on 16/4/21.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSFileHandle (MD5)
 
    @abstract
        NSFileHandle的类别扩展，实现文件的MD5编码
 
 *********************************************************/

@interface NSFileHandle (MD5)

/*!
 * @brief MD5编码字符串并大写
 * @result 编码后字符串
 */
- (NSString *)stringByAddingMD5Encoding;

@end
