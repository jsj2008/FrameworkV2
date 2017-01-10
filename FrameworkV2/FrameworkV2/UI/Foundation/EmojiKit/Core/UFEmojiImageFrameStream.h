//
//  UFEmojiImageFrameStream.h
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmojiImageFrame.h"
#import "UFEmojiImage.h"

/*********************************************************
 
    @class
        UFEmojiImageFrameStream
 
    @abstract
        表情图片帧流，管理帧数据的显示时序
 
 *********************************************************/

@interface UFEmojiImageFrameStream : NSObject

/*!
 * @brief 初始化表情图片帧流
 * @param imageFrames 图片帧流
 * @result 表情图片帧流
 */
- (instancetype)initWithImageFrames:(NSArray<UFEmojiImageFrame *> *)imageFrames;

/*!
 * @brief 初始化表情图片帧流
 * @param image 表情图片
 * @result 表情图片帧流
 */
- (instancetype)initWithImage:(UFEmojiImage *)image;

/*!
 * @brief 图片帧流
 */
@property (nonatomic, readonly) NSArray<UFEmojiImageFrame *> *imageFrames;

/*!
 * @brief 指定时间点的静态图片
 * @param timeOffset 时间点
 * @result 静态图片
 */
- (UIImage *)staticImageAtTimeOffset:(NSTimeInterval)timeOffset;

/*!
 * @brief 指定帧索引的静态图片
 * @param frameIndex 帧索引
 * @result 静态图片
 */
- (UIImage *)staticImageAtFrameIndex:(NSUInteger)frameIndex;

@end
