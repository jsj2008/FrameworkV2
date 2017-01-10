//
//  UFEmoji.h
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFEmojiImage.h"

/*********************************************************
 
    @class
        UFEmoji
 
    @abstract
        表情对象
 
 *********************************************************/

@interface UFEmoji : NSObject

/*!
 * @brief 表情code
 */
@property (nonatomic, copy) NSString *code;

/*!
 * @brief 表情图片
 */
@property (nonatomic) UFEmojiImage *image;

@end
