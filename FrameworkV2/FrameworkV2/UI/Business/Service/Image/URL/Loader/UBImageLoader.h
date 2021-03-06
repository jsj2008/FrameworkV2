//
//  UBImageLoader.h
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UBImageLoaderDelegate;

/*********************************************************
 
    @class
        UBImageLoader
 
    @abstract
        UI图片加载器
 
    @discussion
        加载器在dealloc时会自动停止正在进行的加载操作
 
 *********************************************************/

@interface UBImageLoader : NSObject

/*!
 * @brief 初始化
 * @param URL 图片URL，支持文件URL和HTTP类型URL
 * @result 初始化对象
 */
- (instancetype)initWithURL:(NSURL *)URL;

/*!
 * @brief 图片URL
 */
@property (nonatomic, readonly, copy) NSURL *URL;

/*!
 * @brief 消息代理
 */
@property (nonatomic, weak) id<UBImageLoaderDelegate> delegate;

/*!
 * @brief 是否允许使用本地图片
 * @discussion 默认YES
 */
@property (nonatomic) BOOL enableLocalImage;

/*!
 * @brief 用户字典
 */
@property (nonatomic) NSDictionary *userInfo;

/*!
 * @brief 启动加载
 */
- (void)start;

/*!
 * @brief 取消加载
 */
- (void)cancel;

@end


/*********************************************************
 
    @protocol
        UBImageLoaderDelegate
 
    @abstract
        ImageView图片加载器消息协议
 
 *********************************************************/

@protocol UBImageLoaderDelegate <NSObject>

/*!
 * @brief 图片加载完成
 * @param task 任务
 * @param imageLoader 加载器
 * @param data 图片数据
 */
- (void)imageLoader:(UBImageLoader *)imageLoader didFinishWithError:(NSError *)error imageData:(NSData *)data;

@optional

/*!
 * @brief 图片加载进度
 * @param imageLoader 加载器
 * @param downloadedSize 已下载量
 * @param expectedSize 预期下载量
 */
- (void)imageLoader:(UBImageLoader *)imageLoader didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
