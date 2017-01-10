//
//  UIView+Emoji.h
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmoji.h"
#import "UFAttributedStringEmojiUpdater.h"
#import "UFEmojiCache.h"

/*********************************************************
 
    @enum
        UFViewEmojiImageUpdateType
 
    @abstract
        表情图片更新类型
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFViewEmojiImageUpdateType)
{
    UFViewEmojiImageUpdateByDuration = 0,
    UFViewEmojiImageUpdateByFrame    = 1
};


/*********************************************************
 
    @class
        UFViewEmojiConfiguration
 
    @abstract
        UIView的表情配置
 
 *********************************************************/

@interface UFViewEmojiConfiguration : NSObject

/*!
 * @brief 表情集，键为表情code
 */
@property (nonatomic) NSDictionary<NSString *, UFEmoji *> *emojiSet;

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
@property (nonatomic) UFViewEmojiImageUpdateType imageUpdateType;

@end


/*********************************************************
 
    @category
        UIView (Emoji)
 
    @abstract
        UIView的表情扩展
 
 *********************************************************/

@interface UIView (Emoji) <UFAttributedStringEmojiUpdaterDelegate>

/*!
 * @brief 表情配置
 */
@property (nonatomic) UFViewEmojiConfiguration *emojiConfiguration;

@end


/*********************************************************
 
    @category
        UILabel (Emoji)
 
    @abstract
        UILabel的表情扩展
 
 *********************************************************/

@interface UILabel (Emoji)

/*!
 * @brief 显示表情
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 */
- (void)showEmoji;

/*!
 * @brief 关闭表情
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmoji;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide;

/*!
 * @brief 暂停表情
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmoji;

/*!
 * @brief 继续表情
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmoji;

@end


/*********************************************************
 
    @category
        UIButton (Emoji)
 
    @abstract
        UIButton的表情扩展
 
 *********************************************************/

@interface UIButton (Emoji)

/*!
 * @brief 显示表情
 * @param state 按钮状态
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 * @discussion 在显示表情前，必须为指定状态正确设置attributedTitle
 */
- (void)showEmojiForState:(UIControlState)state;

/*!
 * @brief 关闭表情
 * @param state 按钮状态
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmojiForState:(UIControlState)state;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @param state 按钮状态
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide forState:(UIControlState)state;

/*!
 * @brief 暂停表情
 * @param state 按钮状态
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmojiForState:(UIControlState)state;

/*!
 * @brief 继续表情
 * @param state 按钮状态
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmojiForState:(UIControlState)state;

@end


/*********************************************************
 
    @category
        UITextField (Emoji)
 
    @abstract
        UITextField的表情扩展
 
 *********************************************************/

@interface UITextField (Emoji)

/*!
 * @brief 显示表情
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 */
- (void)showEmoji;

/*!
 * @brief 关闭表情
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmoji;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide;

/*!
 * @brief 暂停表情
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmoji;

/*!
 * @brief 继续表情
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmoji;

@end


/*********************************************************
 
    @category
        UITextView (Emoji)
 
    @abstract
        UITextView的表情扩展
 
 *********************************************************/

@interface UITextView (Emoji)

/*!
 * @brief 显示表情
 * @discussion 若之前已显示表情，将中断之前表情，显示新表情
 */
- (void)showEmoji;

/*!
 * @brief 关闭表情
 * @discussion 关闭之后，所有表情立即失效，并显示纯文本
 */
- (void)closeEmoji;

/*!
 * @brief 隐藏表情
 * @param hide 是否隐藏表情
 * @discussion 隐藏表情，将只显示纯文本，但表情更新机制继续运行；显示表情，将根据更新机制继续显示表情
 */
- (void)hideEmoji:(BOOL)hide;

/*!
 * @brief 暂停表情
 * @discussion 暂停后，表情将定格在暂停时刻的画面
 */
- (void)pauseEmoji;

/*!
 * @brief 继续表情
 * @discussion 继续表情，表情将从暂停时刻后的画面开始显示
 */
- (void)resumeEmoji;

@end


/* example
 
 UFEmoji *emoji = [[UFEmoji alloc] init];
 
 emoji.code = @"a";
 
 UFEmojiGIFImage *image = [[UFEmojiGIFImage alloc] init];
 
 image.GIFPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"];
 
 emoji.image = image;
 
 UFViewEmojiConfiguration *configuration = [[UFViewEmojiConfiguration alloc] init];
 
 configuration.emojiSet = [NSDictionary dictionaryWithObjectsAndKeys:emoji, emoji.code, nil];
 
 configuration.emojiCache = [[UFEmojiCache alloc] init];
 
 configuration.enableAutoUpdate = NO;
 
 configuration.updateFrameInterval = 20;
 
 configuration.imageUpdateType = UFViewEmojiImageUpdateByFrame;
 
 UILabel *label = [[UILabel alloc] init];
 
 label.emojiConfiguration = configuration;
 
 label.text = @"12a34b";
 
 [label showEmoji];
 
 */
