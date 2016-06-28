//
//  UFEmojiSet.h
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmoji.h"

/*********************************************************
 
    @class
        UFEmojiSet
 
    @abstract
        表情集
 
 *********************************************************/

@interface UFEmojiSet : NSObject

/*!
 * @brief 初始化表情集
 * @param emojiDictionary 表情字典
 * @result 表情集
 */
- (instancetype)initWithEmojiDictionary:(NSDictionary<NSString *, UFEmoji *> *)emojiDictionary;

/*!
 * @brief 获取指定的表情
 * @param key 表情键，用于检索表情
 * @result 表情对象
 */
- (UFEmoji *)emojiForKey:(NSString *)key;

@end


/*********************************************************
 
    @category
        UFEmojiSet (Cache)
 
    @abstract
        表情集的扩展，实现缓存相关的功能
 
    @discussion
        对于指定路径的表情对象，在实际使用中会生成响应的UIImage对象使用，生成的UIImage对象会一直存在于内存中，并成为缓存，因此当内存占用过多时，有必要清理这些对象
 
 *********************************************************/

@interface UFEmojiSet (Cache)

/*!
 * @brief 清理缓存
 * @discussion 对于指定表情图片路径的表情对象，清理缓存将清除其产生的历史图片
 */
- (void)cleanCache;

/*!
 * @brief 缓存大小，通过Image大小估算（image.size.width*image.size.height*image.scale）
 * @result 缓存大小
 */
- (NSUInteger)cacheSize;

@end
