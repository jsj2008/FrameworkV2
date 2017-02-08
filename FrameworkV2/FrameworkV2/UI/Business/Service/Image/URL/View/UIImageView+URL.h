//
//  UIImageView+URL.h
//  FrameworkV1
//
//  Created by ww on 16/5/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBViewImageURLLoadingConfiguration.h"
#import "UBImageLoader.h"

#pragma mark - UIImageView (URL)

/*********************************************************
 
    @category
        UIImageView (URL)
 
    @abstract
        UIImageView加载URL图片的扩展
 
    @discussion
        支持加载文件和HTTP图片
 
 *********************************************************/

@interface UIImageView (URL) <UBImageLoaderDelegate>

/*!
 * @brief 图片URL加载配置信息
 */
@property (nonatomic) UBViewImageURLLoadingConfiguration *URLLoadingConfiguration;

/*!
 * @brief 启动图片URL加载
 * @discussion 若已有URL图片正在加载，将会取消正在进行的加载操作并进行新的加载
 * @discussion 若URLLoadingConfiguration已配置，可重复启动加载
 * @param immediately 是否立即启动加载，YES将立即启动加载，NO将在下个循环启动加载，以合并当前循环中的多次加载操作，避免图片重复加载和取消操作
 */
- (void)startURLLoadingImmediately:(BOOL)immediately;

/*!
 * @brief 取消图片URL加载
 */
- (void)cancelURLLoading;

@end


#pragma mark - UIImageView (URLConvenience)

/*********************************************************
 
    @category
        UIImageView (URLConvenience)
 
    @abstract
        UIImageView加载URL图片的快捷方式扩展，是对UIImageView (URL)的封装
 
    @discussion
        类别中的setImageXXX方法都默认不立即启动加载
 
 *********************************************************/

@interface UIImageView (URLConvenience)

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @discussion 默认允许使用本地图片
 * @param URL 图片URL
 */
- (void)setImageWithURL:(NSURL *)URL;

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @discussion 默认允许使用本地图片
 * @param URL 图片URL
 * @param placeHolderImage 占位图，若为nil，不使用占位图
 * @param completion 加载完成的回调
 */
- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage completion:(UBViewImageURLLoadingCompletion)completion;

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @discussion 默认允许使用本地图片
 * @param URL 图片URL
 * @param placeHolderImage 占位图，若为nil，不使用占位图
 * @param failureImage 加载失败时的显示图片，若为nil，不使用该图片，继续显示原图片
 * @param completion 加载完成的回调
 */
- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage failureImage:(UIImage *)failureImage completion:(UBViewImageURLLoadingCompletion)completion;

@end
