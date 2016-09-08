//
//  UIImageView+URL.h
//  FrameworkV1
//
//  Created by ww on 16/5/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - UIImageView (URL)

@class UBImageViewURLLoadingConfiguration;

/*********************************************************
 
    @category
        UIImageView (URL)
 
    @abstract
        UIImageView加载URL图片的扩展
 
    @discussion
        支持加载文件和HTTP图片
 
 *********************************************************/

@interface UIImageView (URL)

/*!
 * @brief 图片URL加载配置信息
 */
@property (nonatomic) UBImageViewURLLoadingConfiguration *URLLoadingConfiguration;

/*!
 * @brief 启动图片URL加载
 * @discussion 若已有URL图片正在加载，将会取消正在进行的加载操作并进行新的加载
 */
- (void)startURLLoading;

/*!
 * @brief 取消图片URL加载
 */
- (void)cancelURLLoading;

@end


#pragma mark - UBImageViewURLLoadingConfiguration


/*!
 * @brief 图片加载完成时的回调block
 * @param URL，图片URL
 * @param error，错误信息
 */
typedef void(^UBImageViewURLLoadingCompletion)(NSURL *URL, NSError *error);

/*!
 * @brief 图片加载进度的回调block
 * @param URL，图片URL
 * @param loadedSize，已下载量
 * @param expectedSize，预期下载量
 */
typedef void(^UBImageViewURLLoadingProgressing)(NSURL *URL, long long loadedSize, long long expectedSize);


/*********************************************************
 
    @class
        UBImageViewURLLoadingConfiguration
 
    @abstract
        图片URL加载配置信息
 
 *********************************************************/

@interface UBImageViewURLLoadingConfiguration : NSObject

/*!
 * @brief 图片URL，支持文件URL和HTTP类型URL
 */
@property (nonatomic, copy) NSURL *URL;

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
@property (nonatomic, copy) UBImageViewURLLoadingCompletion completion;

/*!
 * @brief 图片加载进度的回调block
 */
@property (nonatomic, copy) UBImageViewURLLoadingProgressing progressing;

@end


#pragma mark - UIImageView (URLConvenience)

/*********************************************************
 
    @category
        UIImageView (URLConvenience)
 
    @abstract
        UIImageView加载URL图片的快捷方式扩展，是对UIImageView (URL)的封装
 
 *********************************************************/

@interface UIImageView (URLConvenience)

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @param URL 图片URL
 */
- (void)setImageWithURL:(NSURL *)URL;

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @param URL 图片URL
 * @param placeHolderImage 占位图
 * @param completion 加载完成的回调
 */
- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage completion:(UBImageViewURLLoadingCompletion)completion;

@end
