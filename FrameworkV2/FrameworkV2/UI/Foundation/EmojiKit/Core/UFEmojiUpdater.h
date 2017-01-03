//
//  UFEmojiUpdater.h
//  FrameworkV2
//
//  Created by ww on 03/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFEmoji.h"

/*********************************************************
 
    @class
        UFEmojiUpdater
 
    @abstract
        表情对象更新器
 
    @discussion
        UFEmojiUpdater是抽象类
 
 *********************************************************/

@interface UFEmojiUpdater : NSObject

/*!
 * @brief 初始化表情对象更新器
 * @param emoji 表情对象
 * @result 表情对象更新器
 */
- (instancetype)initWithEmoji:(UFEmoji *)emoji;

/*!
 * @brief 表情对象
 */
@property (nonatomic, copy, readonly) UFEmoji *emoji;

/*!
 * @brief 表情对象是否可更新
 */
@property (nonatomic, readonly) BOOL updatable;

/*!
 * @brief 表情对象当前图片
 * @result 当前图片
 */
@property (nonatomic, readonly) UIImage *currentImage;

/*!
 * @brief 刷新当前表情对象
 */
- (void)updateWithDuration:(NSTimeInterval)duration;

@end


/*********************************************************
 
    @class
        UFEmojiFramingUpdater
 
    @abstract
        按帧刷新图片的表情对象更新器
 
    @discussion
        更新器每次更新图片都取图片的下一帧，忽略更新时间间隔
 
 *********************************************************/

@interface UFEmojiFramingUpdater : UFEmojiUpdater

@end


/*********************************************************
 
    @class
        UFEmojiDurationingUpdater
 
    @abstract
        按图片时间刷新图片的表情对象更新器
 
    @discussion
        更新器每次更新图片都会根据两次刷新间的时间间隔计算当前应当显示的图片
 
 *********************************************************/

@interface UFEmojiDurationingUpdater : UFEmojiUpdater

@end
