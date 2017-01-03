//
//  UFEmoji.h
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFEmojiImage.h"

/*********************************************************
 
    @class
        UFEmoji
 
    @abstract
        表情对象
 
    @discussion
        1，UFEmoji支持使用图片对象或图片路径来表征图片信息
        2，使用图片路径来表征图片信息的UFEmoji对象，在实际使用时可能会生成图片对象作为缓存使用
 
 *********************************************************/

@interface UFEmoji : NSObject <NSCopying>

/*!
 * @brief 表情名字
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief 表情图片
 */
@property (nonatomic) UFEmojiImage *image;

/*!
 * @brief 表情图片路径
 * @discussion 支持png，gif，jpg，jpeg格式文件
 */
@property (nonatomic, copy) NSString *imagePath;

@end


/*********************************************************
 
    @category
        UFEmoji (Path)
 
    @abstract
        表情对象的扩展，实现文件路径相关的功能
 
 *********************************************************/

@interface UFEmoji (Path)

/*!
 * @brief 根据文件路径生成表情图片
 * @discussion 支持png，gif，jpg，jpeg格式文件
 * @param path 文件路径
 * @result 表情图片
 */
- (UFEmojiImage *)imageWithPath:(NSString *)path;

@end
