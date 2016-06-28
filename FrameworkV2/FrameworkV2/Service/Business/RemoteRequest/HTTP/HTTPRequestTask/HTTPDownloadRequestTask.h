//
//  HTTPDownloadRequestTask.h
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestTask.h"

/*********************************************************
 
    @class
        HTTPDownloadRequestTask
 
    @abstract
        HTTP下载请求Task
 
    @discussion
        1，HTTPDownloadRequestTask下载完成后将文件转移到指定位置
        2，HTTPDownloadRequestTask支持断点续传功能
 
 *********************************************************/

@interface HTTPDownloadRequestTask : HTTPRequestTask

/*!
 * @brief 资源URL，下载完成后将文件转移到该URL位置
 * @discussion 使用者需确保URL可用，路径中的目录已被正确创建
 */
@property (nonatomic, copy) NSURL *resourceURL;

/*!
 * @brief 断点续传开关
 */
@property (nonatomic) BOOL resumable;

@end


/*********************************************************
 
    @protocol
        HTTPDownloadRequestTaskDelegate
 
    @abstract
        HTTP下载请求Task的代理协议
 
 *********************************************************/

@protocol HTTPDownloadRequestTaskDelegate <NSObject>

/*!
 * @brief 请求结束
 * @param task 请求Task
 * @param error 错误信息
 * @param response 响应信息
 */
- (void)HTTPDownloadRequestTask:(HTTPDownloadRequestTask *)task didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response;

@optional

/*!
 * @brief 下载进度通知
 * @param task 请求Task
 * @param bytesWritten 两次通知间的下载量
 * @param totalBytesWritten 已下载总量
 * @param totalBytesExpectedToWrite 期望下载总量（资源大小）
 */
- (void)HTTPDownloadRequestTask:(HTTPDownloadRequestTask *)task didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

@end
