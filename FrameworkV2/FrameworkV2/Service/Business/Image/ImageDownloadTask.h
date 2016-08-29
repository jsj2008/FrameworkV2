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
        图片管理器下载任务
 
 *********************************************************/

@interface ImageDownloadTask : ServiceTask

/*!
 * @brief 图片URL
 */
@property (nonatomic, copy) NSURL *imageURL;

/*!
 * @brief 资源URL，下载完成后将文件转移到该URL位置
 * @discussion 使用者需确保URL可用，路径中的目录已被正确创建
 */
@property (nonatomic, copy) NSURL *resourceURL;

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
- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error;

/*!
 * @brief 图片下载进度
 * @param task 任务
 * @param downloadedSize 已下载量
 * @param expectedSize 预期下载量
 */
- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
