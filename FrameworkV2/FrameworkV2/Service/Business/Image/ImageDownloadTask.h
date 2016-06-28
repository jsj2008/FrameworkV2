//
//  ImageDownloadTask.h
//  FrameworkV1
//
//  Created by ww on 16/5/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "ServiceTask.h"

@protocol ImageDownloadTaskDelegate;

/*********************************************************
 
    @class
        ImageDownloadTask
 
    @abstract
        图片下载任务
 
    @discussion
        支持加载文件和HTTP图片
 
 *********************************************************/

@interface ImageDownloadTask : ServiceTask

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

@end


/*********************************************************
 
    @protocol
        ImageDownloadTaskDelegate
 
    @abstract
        URL图片下载消息协议
 
 *********************************************************/

@protocol ImageDownloadTaskDelegate <NSObject>

/*!
 * @brief 图片下载完成
 * @param task 任务
 * @param error 错误信息
 * @param data 图片数据
 */
- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data;

@optional

/*!
 * @brief 图片下载进度
 * @param task 任务
 * @param downloadedSize 已下载量
 * @param expectedSize 预期下载量
 */
- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize;

@end
