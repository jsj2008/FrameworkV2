//
//  UFEmojiCache.h
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmoji.h"
#import "UFEmojiImageFrameStream.h"

@class UFCachedEmojiImage;


/*********************************************************
 
    @class
        UFEmojiCache
 
    @abstract
        表情缓存
 
 *********************************************************/

@interface UFEmojiCache : NSObject

/*!
 * @brief 单例
 */
+ (UFEmojiCache *)sharedInstance;

/*!
 * @brief 最大的缓存表情数量
 */
@property (nonatomic) NSUInteger maxCachedEmojiCount;

/*!
 * @brief 是否启用自动缓存清理
 */
@property (nonatomic) BOOL enableAutoCleanCache;

/*!
 * @brief 设置表情图片缓存
 * @param image 表情图片缓存
 * @param emoji 表情对象
 */
- (void)setCachedEmojiImage:(UFCachedEmojiImage *)image forEmoji:(UFEmoji *)emoji;

/*!
 * @brief 获取表情图片缓存
 * @param emoji 表情对象
 * @result 表情图片缓存
 */
- (UFCachedEmojiImage *)cachedEmojiImageForEmoji:(UFEmoji *)emoji;

/*!
 * @brief 清理所有表情图片缓存
 */
- (void)removeAllCachedEmojiImages;

@end


/*********************************************************
 
    @class
        UFCachedEmojiImage
 
    @abstract
        缓存的表情图片
 
 *********************************************************/

@interface UFCachedEmojiImage : NSObject

/*!
 * @brief 图片帧流
 */
@property (nonatomic) UFEmojiImageFrameStream *frameStream;

@end
