//
//  UIImageView+AnimationImage.h
//  Test
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFImageAnimationUpdater.h"

/*********************************************************
 
    @category
        UIImageView (AnimationImage)
 
    @abstract
        UIImageView的图片动画扩展
 
 *********************************************************/

@interface UIImageView (AnimationImage) <UFImageAnimationUpdaterDelegate>

/*!
 * @brief 图片动画帧
 */
@property (nonatomic) NSArray<UFImageAnimationFrame *> *imageAnimationFrames;

/*!
 * @brief 动画帧间隔
 */
@property (nonatomic) NSUInteger imageAnimationFrameInterval;

/*!
 * @brief 开启图片动画
 */
- (void)startImageAnimating;

/*!
 * @brief 停止图片动画
 */
- (void)stopImageAnimating;

/*!
 * @brief 暂停图片动画
 */
- (void)pauseImageAnimating;

/*!
 * @brief 继续图片动画
 */
- (void)resumeImageAnimating;

@end
