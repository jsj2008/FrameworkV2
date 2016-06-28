//
//  NSString+Character.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSString (Character)
 
    @abstract
        NSString的字符处理扩展
 
 *********************************************************/

@interface NSString (Character)

/*!
 * @brief 删除前后缀字符串后的字符串
 * @discussion 只有标记字符串同时为前后缀，且前后缀的标记字符串无交叉重复时才生效
 * @discussion 即：对于字符串@"ababab"，指定标记为@"abab"，删除操作将无效，因为此时前缀和后缀@"abab"拥有交叉字符@"ab"
 * @result 处理后的字符串
 */
- (NSString *)stringByDeletingBothPrefixAndSuffixMarks:(NSString *)mark;

/*!
 * @brief 全半角字节数，一个半角字符算一个字节，中文字符则算两个字节
 * @result 字节数
 */
- (NSInteger)fullHalfWidthLengthOfBytes;

@end
