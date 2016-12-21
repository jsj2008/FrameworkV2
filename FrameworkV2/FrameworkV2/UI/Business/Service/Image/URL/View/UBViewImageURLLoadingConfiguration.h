//
//  UBViewImageURLLoadingConfiguration.h
//  FrameworkV2
//
//  Created by ww on 20/12/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @brief 图片加载完成时的回调block
 * @param error，错误信息
 */
typedef void(^UBViewImageURLLoadingCompletion)(NSError *error);

/*!
 * @brief 图片加载进度的回调block
 * @param loadedSize，已下载量
 * @param expectedSize，预期下载量
 */
typedef void(^UBViewImageURLLoadingProgressing)(long long loadedSize, long long expectedSize);


/*********************************************************
 
    @class
        UBViewImageURLLoadingConfiguration
 
    @abstract
        UIView的图片URL加载配置信息
 
 *********************************************************/

@interface UBViewImageURLLoadingConfiguration : NSObject

/*!
 * @brief 图片URL，支持文件URL和HTTP类型URL
 */
@property (nonatomic, copy) NSURL *URL;

/*!
 * @brief 是否使用本地图片
 */
@property (nonatomic) BOOL enableLocalImage;

/*!
 * @brief 是否使用图片加载时的占位图
 */
@property (nonatomic, getter=isPlaceHolderImageEnabled) BOOL enablePlaceHolderImage;

/*!
 * @brief 图片加载时的占位图
 */
@property (nonatomic) UIImage *placeHolderImage;

/*!
 * @brief 是否使用图片加载失败时的图
 */
@property (nonatomic, getter=isFailureImageEnabled) BOOL enableFailureImage;

/*!
 * @brief 图片加载失败时的图
 */
@property (nonatomic) UIImage *failureImage;

/*!
 * @brief 图片加载完成时的回调block
 */
@property (nonatomic, copy) UBViewImageURLLoadingCompletion completion;

/*!
 * @brief 图片加载进度的回调block
 */
@property (nonatomic, copy) UBViewImageURLLoadingProgressing progressing;

@end
