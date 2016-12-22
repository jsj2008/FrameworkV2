//
//  NSURL+ImageSize.h
//  FrameworkV2
//
//  Created by ww on 16/8/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @category
        NSURL (ImageSize)
 
    @abstract
        NSURL的图片扩展
 
 *********************************************************/

@interface NSURL (ImageSize)

/*!
 * @brief 生成带坐标点尺寸的图片URL
 * @param pointSize 图片坐标点的尺寸
 * @result 图片URL
 */
- (NSURL *)imageURLWithPointSize:(CGSize)pointSize;

@end
