//
//  UFImageAnimationUpdater.h
//  Test
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFImageAnimationFrame.h"

@protocol UFImageAnimationUpdaterDelegate;


/*********************************************************
 
    @class
        UFImageAnimationUpdater
 
    @abstract
        图片动画更新器
 
 *********************************************************/

@interface UFImageAnimationUpdater : NSObject

/*!
 * @brief 初始化图片动画更新器
 * @param animationFrames 图片动画帧
 * @result 图片动画更新器
 */
- (instancetype)initWithAnimationFrames:(NSArray<UFImageAnimationFrame *> *)animationFrames;

/*!
 * @brief 图片动画帧
 */
@property (nonatomic, readonly) NSArray<UFImageAnimationFrame *> *animationFrames;

/*!
 * @brief 动画帧间隔
 */
@property (nonatomic) NSUInteger frameInterval;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<UFImageAnimationUpdaterDelegate> delegate;

/*!
 * @brief 启动动画更新
 * @discussion 启动后会立即执行一次动画的刷新
 */
- (void)startUpdating;

/*!
 * @brief 停止动画更新
 */
- (void)stopUpdating;

/*!
 * @brief 暂停动画更新
 */
- (void)pauseUpdating;

/*!
 * @brief 继续动画更新
 */
- (void)resumeUpdating;

/*!
 * @brief 当前动画图片
 * @result 当前动画图片
 */
- (UIImage *)currentImage;

@end


/*********************************************************
 
    @protocol
        UFImageAnimationUpdaterDelegate
 
    @abstract
        图片动画更新器
 
 *********************************************************/

@protocol UFImageAnimationUpdaterDelegate <NSObject>

/*!
 * @brief 更新动画并得到当前帧的图片
 * @param updater 更新器
 * @param image 当前帧的图片
 */
- (void)imageAnimationUpdater:(UFImageAnimationUpdater *)updater didUpdateImage:(UIImage *)image;

@end
