//
//  UFEmojiImageSequenceUpdater.h
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFEmojiImageFrameStream.h"

/*********************************************************
 
    @class
        UFAttributedStringEmojiUpdater
 
    @abstract
        表情更新器
 
    @discussion
        UFEmojiImageUpdater是抽象类
 
 *********************************************************/

@interface UFEmojiImageUpdater : NSObject

/*!
 * @brief 初始化表情图片更新器
 * @param emojiImageFrameStream 表情图片帧流
 * @result 图片更新器
 */
- (instancetype)initWithEmojiImageFrameStream:(UFEmojiImageFrameStream *)emojiImageFrameStream;

/*!
 * @brief 表情图片帧流
 */
@property (nonatomic, readonly) UFEmojiImageFrameStream *imageFrameStream;

/*!
 * @brief 图片是否支持更新
 * @discussion 静态图片不支持更新
 * @result 图片是否支持更新
 */
- (BOOL)imageUpdatable;

/*!
 * @brief 图片向前推进指定时间
 */
- (void)advanceByDuration:(NSTimeInterval)duration;

/*!
 * @brief 当前显示的静态图片
 */
- (UIImage *)currentStaticImage;

@end


/*********************************************************
 
    @class
        UFEmojiImageByDurationUpdater
 
    @abstract
        按图片显示时间更新的表情更新器
 
 *********************************************************/

@interface UFEmojiImageByDurationUpdater : UFEmojiImageUpdater

@end


/*********************************************************
 
    @class
        UFEmojiImageByFrameUpdater
 
    @abstract
        按帧更新的表情更新器
 
 *********************************************************/

@interface UFEmojiImageByFrameUpdater : UFEmojiImageUpdater

@end
