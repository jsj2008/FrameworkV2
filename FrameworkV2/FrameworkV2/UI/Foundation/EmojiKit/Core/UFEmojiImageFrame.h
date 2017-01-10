//
//  UFEmojiImageFrame.h
//  Test
//
//  Created by ww on 05/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFEmojiImageFrame
 
    @abstract
        表情图片帧
 
 *********************************************************/

@interface UFEmojiImageFrame : NSObject

/*!
 * @brief UI图片对象
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
