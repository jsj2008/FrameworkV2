//
//  UFAttributedStringEmojiUpdater.h
//  Test
//
//  Created by ww on 15/12/24.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmojiSet.h"

/*********************************************************
 
    @enum
        UFEmojiUpdateImageType
 
    @abstract
        表情图片更新类型
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFEmojiUpdateImageType)
{
    UFEmojiUpdateImageType_FrameFixed = 0,      // 按帧刷新
    UFEmojiUpdateImageType_DurationFixed        // 按图片时间刷新
};


@protocol UFAttributedStringEmojiUpdaterDelegate;


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
 * @result 表情更新器
 */
- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString;

/*!
 * @brief 表情字符串
 */
@property (nonatomic, readonly) NSAttributedString *attributedString;

/*!
 * @brief 表情匹配的正则表达式
 * @discussion 更新器通过匹配正则表达式识别表情
 */
@property (nonatomic, copy) NSString *pattern;

/*!
 * @brief 表情集
 * @discussion 更新器只识别表情集内的表情
 */
@property (nonatomic) UFEmojiSet *emojiSet;

/*!
 * @brief 允许自动更新
 * @discussion 若允许，更新器内部根据表情数据自动更新表情显示效果（适用于动态表情）；若不允许，更新器只会显示表情当前的图片数据
 * @discussion 默认YES
 */
@property (nonatomic, getter=isAutoUpdateEnabled) BOOL enableAutoUpdate;

/*!
 * @brief 刷新图片方式
 * @discussion 默认UFEmojiUpdateImageType_FrameFixed
 */
@property (nonatomic) UFEmojiUpdateImageType upateImageType;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<UFAttributedStringEmojiUpdaterDelegate> delegate;

/*!
 * @brief 用户数据字典，透传数据
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
