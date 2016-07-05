//
//  UBPictureBrowsePicture.h
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UBPictureBrowsePicture
 
    @abstract
        浏览图片
 
 *********************************************************/

@interface UBPictureBrowsePicture : NSObject

/*!
 * @brief 图片ID
 */
@property (nonatomic, copy) NSString *pictureId;

/*!
 * @brief 图片文本
 */
@property (nonatomic, copy) NSString *text;

@end


/*********************************************************
 
    @class
        UBPictureBrowseURLPicture
 
    @abstract
        URL型浏览图片
 
 *********************************************************/

@interface UBPictureBrowseURLPicture : UBPictureBrowsePicture

/*!
 * @brief 图片URL
 */
@property (nonatomic, copy) NSURL *URL;

@end


/*********************************************************
 
    @class
        UBPictureBrowseImagePicture
 
    @abstract
        Image型浏览图片
 
 *********************************************************/

@interface UBPictureBrowseImagePicture : UBPictureBrowsePicture

/*!
 * @brief 图片Image
 */
@property (nonatomic) UIImage *image;

@end


/*********************************************************
 
    @category
        UBPictureBrowseURLPicture (Download)
 
    @abstract
        URL型浏览图片的下载扩展
 
 *********************************************************/

@interface UBPictureBrowseURLPicture (Download)

/*!
 * @brief 下载错误
 */
@property (nonatomic) NSError *downloadError;

@end
