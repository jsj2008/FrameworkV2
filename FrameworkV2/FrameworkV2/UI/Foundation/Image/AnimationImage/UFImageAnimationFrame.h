//
//  UFImageAnimationFrame.h
//  Test
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFImageAnimationFrame
 
    @abstract
        图片动画帧
 
 *********************************************************/

@interface UFImageAnimationFrame : NSObject

/*!
 * @brief 图片对象
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 帧起始时间
 */
@property (nonatomic) NSTimeInterval startTime;

/*!
 * @brief 帧结束时间
 */
@property (nonatomic) NSTimeInterval endTime;

@end


/*********************************************************
 
    @category
        UFImageAnimationFrame (Creation)
 
    @abstract
        UFImageAnimationFrame的创建扩展
 
 *********************************************************/


@interface UFImageAnimationFrame (Creation)

/*!
 * @brief 根据GIF数据创建图片动画帧
 * @param GIFData GIF数据
 * @result 图片动画帧
 */
+ (NSArray<UFImageAnimationFrame *> *)animationFramesWithGIFData:(NSData *)GIFData;

@end
