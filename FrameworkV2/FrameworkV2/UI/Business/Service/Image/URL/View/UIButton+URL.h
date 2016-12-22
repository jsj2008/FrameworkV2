//
//  UIButton+URL.h
//  FrameworkV2
//
//  Created by ww on 20/12/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBViewImageURLLoadingConfiguration.h"
#import "UBImageLoader.h"

#pragma mark - UIButton (URL)

/*********************************************************
 
    @category
        UIButton (URL)
 
    @abstract
        UIButton加载URL图片的扩展
 
    @discussion
        支持加载文件和HTTP图片
 
 *********************************************************/

@interface UIButton (URL) <UBImageLoaderDelegate>

/*!
 * @brief 图片URL加载配置信息
 * @discussion key：UIControlState的NSNumber对象，value：UBViewImageURLLoadingConfiguration
 */
@property (nonatomic) NSDictionary<NSNumber *, UBViewImageURLLoadingConfiguration *> *URLLoadingConfigurations;

/*!
 * @brief 启动图片URL加载
 * @discussion 若已有URL图片正在加载，将会取消正在进行的加载操作并进行新的加载
 * @discussion 若URLLoadingConfiguration已配置，可重复启动加载
 * @param state 按钮状态
 */
- (void)startURLLoadingForState:(UIControlState)state;

/*!
 * @brief 启动所有图片URL加载
 * @discussion 若已有URL图片正在加载，将会取消正在进行的加载操作并进行新的加载
 * @discussion 若URLLoadingConfiguration已配置，可重复启动加载
 */
- (void)startAllURLLoading;

/*!
 * @brief 取消图片URL加载
 * @param state 按钮状态
 */
- (void)cancelURLLoadingForState:(UIControlState)state;

/*!
 * @brief 取消所有图片URL加载
 */
- (void)cancelAllURLLoading;

@end


#pragma mark - UIButton (URLConvenience)

/*********************************************************
 
    @category
        UIButton (URLConvenience)
 
    @abstract
        UIButton加载URL图片的快捷方式扩展，是对UIButton (URL)的封装
 
 *********************************************************/

@interface UIButton (URLConvenience)

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @param URL 图片URL
 * @param state 按钮状态
 */
- (void)setImageWithURL:(NSURL *)URL forState:(UIControlState)state;

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @param URL 图片URL
 * @param placeHolderImage 占位图
 * @param completion 加载完成的回调
 * @param state 按钮状态
 */
- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage completion:(UBViewImageURLLoadingCompletion)completion forState:(UIControlState)state;

/*!
 * @brief 加载URL图片
 * @discussion 内部自动配置URLLoadingConfiguration并立即启动加载
 * @discussion 默认允许使用本地图片
 * @param URL 图片URL
 * @param placeHolderImage 占位图，若为nil，不使用占位图
 * @param failureImage 加载失败时的显示图片，若为nil，不使用该图片，继续显示原图片
 * @param completion 加载完成的回调
 * @param state 按钮状态
 */
- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage failureImage:(UIImage *)failureImage completion:(UBViewImageURLLoadingCompletion)completion forState:(UIControlState)state;

@end
