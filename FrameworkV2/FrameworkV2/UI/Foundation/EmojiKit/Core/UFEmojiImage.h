//
//  UFEmojiImage.h
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UFEmojiImageFragment;


/*********************************************************
 
    @class
        UFEmojiImage
 
    @abstract
        表情图片
 
    @discussion
        UFEmojiImage是抽象类
 
 *********************************************************/

@interface UFEmojiImage : NSObject

/*!
 * @brief 生成图片片段
 * @result 图片片段
 */
- (NSArray<UFEmojiImageFragment *> *)imageFragments;

@end


/*********************************************************
 
    @class
        UFEmojiStaticUIImage
 
    @abstract
        静态表情图片
 
 *********************************************************/

@interface UFEmojiStaticUIImage : UFEmojiImage

/*!
 * @brief UI图片对象
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 图片显示时间
 */
@property (nonatomic) NSTimeInterval duration;

@end


/*********************************************************
 
    @class
        UFEmojiStaticFileImage
 
    @abstract
        静态文件表情图片
 
 *********************************************************/

@interface UFEmojiStaticFileImage : UFEmojiImage

/*!
 * @brief 图片文件路径
 */
@property (nonatomic, copy) NSString *imageFilePath;

/*!
 * @brief 图片显示时间
 */
@property (nonatomic) NSTimeInterval duration;

@end


/*********************************************************
 
    @class
        UFEmojiGIFImage
 
    @abstract
        GIF文件表情图片
 
 *********************************************************/

@interface UFEmojiGIFImage : UFEmojiImage

/*!
 * @brief GIF图片文件路径
 */
@property (nonatomic, copy) NSString *GIFPath;

@end


/*********************************************************
 
    @class
        UFEmojiGroupedImage
 
    @abstract
        组合型表情图片
 
 *********************************************************/

@interface UFEmojiGroupedImage : UFEmojiImage

/*!
 * @brief GIF图片文件路径
 */
@property (nonatomic) NSArray<UFEmojiImage *> *groupedImages;

@end


/*********************************************************
 
    @class
        UFEmojiImageFragment
 
    @abstract
        表情图片片段
 
 *********************************************************/

@interface UFEmojiImageFragment : NSObject

/*!
 * @brief UI图片
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 图片显示时间
 */
@property (nonatomic) NSTimeInterval duration;

@end
