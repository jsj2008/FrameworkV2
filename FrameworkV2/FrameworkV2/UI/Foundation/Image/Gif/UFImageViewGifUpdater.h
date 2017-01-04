//
//  UFImageViewGifUpdater.h
//  Test
//
//  Created by ww on 16/3/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFImageViewGifUpdater
 
    @abstract
        gif图片更新器
 
    @discussion
        UFImageViewGifUpdater是抽象类
 
 *********************************************************/

@interface UFImageViewGifUpdater : NSObject

- (instancetype)initWithGifData:(NSData *)gifData;

/*!
 * @brief 图片视图对象
 */
@property (nonatomic, weak) UIImageView *imageView;

/*!
 * @brief gif数据
 */
@property (nonatomic, readonly) NSData *gifData;

/*!
 * @brief 启动gif更新
 */
- (void)startUpdating;

/*!
 * @brief 停止gif更新
 */
- (void)stopUpdating;

/*!
 * @brief 暂停gif更新
 */
- (void)pauseUpdating;

/*!
 * @brief 继续gif更新
 */
- (void)resumeUpdating;

@end


/*********************************************************
 
    @class
        UFImageViewGifUpdater
 
    @abstract
        按帧刷新的gif图片更新器
 
    @discussion
        更新器每次更新图片都取图片的下一帧，忽略更新时间间隔
 
 *********************************************************/

@interface UFImageViewFramingGifUpdater : UFImageViewGifUpdater

@end


/*********************************************************
 
    @class
        UFImageViewDurationingGifUpdater
 
    @abstract
        按图片时间刷新图片的gif图片更新器
 
    @discussion
        更新器每次更新图片都会根据每帧图片的显示时间计算当前应当显示的图片
 
 *********************************************************/

@interface UFImageViewDurationingGifUpdater : UFImageViewGifUpdater

@end


/*********************************************************
 
    @class
        UFImageViewGifImageSource
 
    @abstract
        gif图片数据源
 
 *********************************************************/

@interface UFImageViewGifImageSource : NSObject

/*!
 * @brief 图片数据
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 图片持续时间
 * @discussion 在动态gif中用于控制图片切换
 */
@property (nonatomic) NSTimeInterval duration;

@end
