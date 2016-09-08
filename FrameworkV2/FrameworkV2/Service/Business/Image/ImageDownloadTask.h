//
//  ImageDownloadTask.h
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ServiceTask.h"

@protocol ImageDownloadTaskDelegate;


/*********************************************************
 
    @class
        ImageDownloadTask
 
    @abstract
        图片下载任务
 
    @discussion
        下载任务内部会将图片数据存入图片存储区
 
 *********************************************************/

@interface ImageDownloadTask : ServiceTask

/*!
 * @brief 图片URL
 * @discussion 支持文件和HTTP类型URL
 */
@property (nonatomic, copy) NSURL *imageURL;

@end


/*********************************************************
 
    @protocol
        ImageDownloadTaskDelegate
 
    @abstract
        图片管理器下载任务代理消息
 
 *********************************************************/

@protocol ImageDownloadTaskDelegate <NSObject>

/*!
 * @brief 图片下载完成
 * @param task 任务
 * @param error 错误信息
 * @param data 图片数据
 */
- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error data:(NSData *)data;

/*!
 * @brief 图片下载进度
 * @param task 任务
 * @param downloadedSize 已下载量
 * @param expectedSize 预期下载量
 */
- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
