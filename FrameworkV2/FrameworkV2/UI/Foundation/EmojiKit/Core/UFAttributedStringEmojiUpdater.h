//
//  UFAttributedStringEmojiUpdater.h
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmoji.h"
#import "UFEmojiCache.h"

@protocol UFAttributedStringEmojiUpdaterDelegate;


/*********************************************************
 
    @enum
        UFAttributedStringEmojiImageUpdateType
 
    @abstract
        表情图片更新类型
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFAttributedStringEmojiImageUpdateType)
{
    UFAttributedStringEmojiImageUpdateByDuration  = 0,     // 每次刷新都根据表情的图片数据计算下一帧应显示的图片
    UFAttributedStringEmojiImageUpdateByFrame     = 1      // 每次刷新都显示表情的下一帧图片，效率更高，速度更快，但刷新频率失真
};


/*********************************************************
 
    @class
        UFAttributedStringEmojiUpdater
 
    @abstract
        表情更新器
 
 *********************************************************/

@interface UFAttributedStringEmojiUpdater : NSObject

/*!
 * @brief 初始化表情更新器
 * @param attributedString 表情字符串
 * @param emojies 表情集，键为表情code
 * @result 表情更新器
 */
- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString emojies:(NSDictionary<NSString *, UFEmoji *> *)emojies;

/*!
 * @brief 表情字符串
 */
@property (nonatomic, copy, readonly) NSAttributedString *attributedString;

/*!
 * @brief 表情集
 */
@property (nonatomic, readonly) NSDictionary<NSString *, UFEmoji *> *emojies;

/*!
 * @brief 表情缓存
 * @discussion 使用表情缓存可以加速表情图片的刷新，避免每次都重新加载表情数据
 */
@property (nonatomic) UFEmojiCache *emojiCache;

/*!
 * @brief 允许自动更新
 * @discussion 若允许，更新器内部根据表情数据自动更新表情显示效果（适用于动态表情）；若不允许，更新器只会显示表情当前的图片数据
 * @discussion 默认YES
 */
@property (nonatomic, getter=isAutoUpdateEnabled) BOOL enableAutoUpdate;

/*!
 * @brief 表情数据刷新时间间隔
 */
@property (nonatomic) NSUInteger updateFrameInterval;

/*!
 * @brief 表情图片刷新方式
 */
@property (nonatomic) UFAttributedStringEmojiImageUpdateType imageUpdateType;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<UFAttributedStringEmojiUpdaterDelegate> delegate;

/*!
 * @brief 用户字典，透传
 */
@property (nonatomic) NSDictionary *userInfo;

/*!
 * @brief 启动表情更新
 * @discussion 未启动表情，只显示表情的编码，不会显示图片数据
 * @discussion 启动后会立即执行一次表情数据的刷新
 */
- (void)startUpdating;

/*!
 * @brief 停止表情更新
 */
- (void)stopUpdating;

/*!
 * @brief 暂停表情更新
 */
- (void)pauseUpdating;

/*!
 * @brief 继续表情更新
 */
- (void)resumeUpdating;

/*!
 * @brief 当前表情图片化后的字符串
 * @result 图片化后的表情字符串
 */
- (NSAttributedString *)currentUsableEmojiedAttributedString;

@end


/*********************************************************
 
    @protocol
        UFAttributedStringEmojiUpdaterDelegate
 
    @abstract
        表情更新器代理方法
 
 *********************************************************/

@protocol UFAttributedStringEmojiUpdaterDelegate <NSObject>

/*!
 * @brief 表情更新器更新表情并得到表情字符串
 * @param updater 更新器
 * @param emojiedAttributedString 表情字符串
 */
- (void)attributedStringEmojiUpdater:(UFAttributedStringEmojiUpdater *)updater didUpdateEmojiedAttributedString:(NSAttributedString *)emojiedAttributedString;

@end
