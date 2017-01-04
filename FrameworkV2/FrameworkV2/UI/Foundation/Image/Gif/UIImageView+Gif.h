//
//  UIImageView+Gif.h
//  Test
//
//  Created by ww on 16/3/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @enum
        UFEmojiUpdateImageType
 
    @abstract
        表情图片更新类型
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFGifImageUpdateType)
{
    UFGifImageUpdateType_ByFrame = 0,      // 按帧刷新
    UFGifImageUpdateType_ByImageDuration   // 按图片时间刷新，计算量较大
};


/*********************************************************
 
    @category
        UIImageView (Gif)
 
    @abstract
        UIImageView的gif扩展
 
 *********************************************************/

@interface UIImageView (Gif)

/*!
 * @brief gif数据
 */
@property (nonatomic) NSData *gifData;

/*!
 * @brief 图片更新方式
 * @discussion 默认UFGifImageUpdateType_ByFrame
 */
@property (nonatomic) UFGifImageUpdateType gifUpdateType;

/*!
 * @brief 启动gif更新
 */
- (void)startGifAnimating;

/*!
 * @brief 停止gif更新
 */
- (void)stopGifAnimating;

/*!
 * @brief 暂停gif更新
 */
- (void)pauseGifAnimating;

/*!
 * @brief 继续gif更新
 */
- (void)resumeGifAnimating;

@end
