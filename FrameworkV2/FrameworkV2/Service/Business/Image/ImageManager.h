//
//  ImageManager.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/10/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  ImageManagerDelegate;


/*********************************************************
 
    @class
        ImageManager
 
    @abstract
        图片管理器
 
    @discussion
        1，管理器的操作和通知都是线程安全的
        2，管理器内部调度ImageDownloadTask实现图片下载
        3，管理器实现了图片合并下载和本地存储功能
 
 *********************************************************/

@interface ImageManager : NSObject

/*!
 * @brief 单例
 */
+ (ImageManager *)sharedInstance;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 停止
 */
- (void)stop;

/*!
 * @brief 下载图片
 * @param URL 图片URL，支持HTTP和文件URL
 * @param observer 下载操作观察者，若为nil，将启动一个无观察者的下载任务，除非停止管理器工作，否则无法取消该下载任务
 * @discussion 下载通知将在本方法执行的线程上发送
 */
- (void)downLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDelegate>)observer;

/*!
 * @brief 取消下载图片
 * @param URL 图片URL
 * @param observer 下载操作观察者，nil无效
 */
- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDelegate>)observer;

/*!
 * @brief 取消下载图片
 * @param URL 图片URL
 */
- (void)cancelDownLoadImageByURL:(NSURL *)URL;

/*!
 * @brief 本地图片数据
 * @param URL 图片URL，支持HTTP和文件URL
 * @result 图片数据
 */
- (NSData *)localImageDataForURL:(NSURL *)URL;

@end


/*********************************************************
 
    @protocol
        ImageManagerDelegate
 
    @abstract
        图片管理器图片下载协议
 
 *********************************************************/

@protocol ImageManagerDelegate <NSObject>

/*!
 * @brief 图片下载完成
 * @param manager 管理器
 * @param URL 图片URL
 * @param successfully 下载是否成功
 * @param data 图片数据
 */
- (void)imageManager:(ImageManager *)manager didFinishDownloadImageByURL:(NSURL *)URL withError:(NSError *)error imageData:(NSData *)data;

@optional

/*!
 * @brief 图片下载进度
 * @param manager 管理器
 * @param URL 图片URL
 * @param downloadedSize 已下载量
 * @param expectedSize 预期下载量
 */
- (void)imageManager:(ImageManager *)manager didDownloadImageByURL:(NSURL *)URL withDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
