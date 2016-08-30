//
//  ImageManager.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/10/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  UBImageDownloadManagerDelegate;


/*********************************************************
 
    @class
        UBImageDownloadManager
 
    @abstract
        图片下载管理器
 
    @discussion
        1，管理器内部调度ImageDownloadTask实现图片下载
        2，管理器实现了图片合并下载和本地存储功能
 
 *********************************************************/

@interface UBImageDownloadManager : NSObject

/*!
 * @brief 单例
 */
+ (UBImageDownloadManager *)sharedInstance;

/*!
 * @brief 下载图片
 * @param URL 图片URL，支持HTTP和文件URL
 * @param observer 下载操作观察者，若为nil，将启动一个无观察者的下载任务
 */
- (void)downLoadImageByURL:(NSURL *)URL withObserver:(id<UBImageDownloadManagerDelegate>)observer;

/*!
 * @brief 取消下载图片
 * @param URL 图片URL
 * @param observer 下载操作观察者，nil无效
 */
- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<UBImageDownloadManagerDelegate>)observer;

/*!
 * @brief 取消下载图片
 * @param URL 图片URL
 */
- (void)cancelDownLoadImageByURL:(NSURL *)URL;

@end


/*********************************************************
 
    @protocol
        UBImageDownloadManagerDelegate
 
    @abstract
        图片下载管理器协议
 
 *********************************************************/

@protocol UBImageDownloadManagerDelegate <NSObject>

/*!
 * @brief 图片下载完成
 * @param manager 管理器
 * @param URL 图片URL
 * @param error 错误信息
 * @param data 图片数据
 */
- (void)imageDownloadManager:(UBImageDownloadManager *)manager didFinishDownloadImageByURL:(NSURL *)URL withError:(NSError *)error imageData:(NSData *)data;

@optional

/*!
 * @brief 图片下载进度
 * @param manager 管理器
 * @param URL 图片URL
 * @param downloadedSize 已下载量
 * @param expectedSize 预期下载量
 */
- (void)imageDownloadManager:(UBImageDownloadManager *)manager didDownloadImageByURL:(NSURL *)URL withDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
