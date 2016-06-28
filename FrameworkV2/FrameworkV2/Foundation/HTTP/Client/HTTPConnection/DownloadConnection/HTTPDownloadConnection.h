//
//  HTTPDownloadConnection.h
//  Test1
//
//  Created by ww on 16/4/11.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnection.h"
#import "HTTPConnectionResumeStorage.h"

@class HTTPDownloadConnectionResumeConfiguration;

@protocol HTTPDownloadConnectionDelegate;


/*********************************************************
 
    @class
        HTTPDownloadConnection
 
    @abstract
        HTTP下载连接，用于下载远端资源
 
    @discussion
        1，HTTPDownloadConnection支持断点续传
 
 *********************************************************/

@interface HTTPDownloadConnection : HTTPConnection

/*!
 * @brief 初始化
 * @param task downloadTask
 * @result 初始化后的对象
 */
- (instancetype)initWithURLSessionDownloadTask:(NSURLSessionDownloadTask *)task;

/*!
 * @brief 初始化
 * @param request 请求信息
 * @param resumeConfiguration 断点续传配置信息
 * @param session 会话信息
 * @result 初始化后的对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request resumeConfiguration:(HTTPDownloadConnectionResumeConfiguration *)resumeConfiguration session:(HTTPSession *)session;

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<HTTPDownloadConnectionDelegate> delegate;

/*!
 * @brief 暂停
 */
- (void)pause;

/*!
 * @brief 继续
 */
- (void)resume;

@end


/*********************************************************
 
    @protocol
        HTTPDownloadConnectionDelegate
 
    @abstract
        HTTP下载连接的delegate通知
 
 *********************************************************/

@protocol HTTPDownloadConnectionDelegate <NSObject>

/*!
 * @brief 请求结束
 * @param downloadConnection 下载连接
 * @param error 错误信息
 * @param response 响应信息
 */
- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response;

@optional

/*!
 * @brief 结束下载
 * @param downloadConnection 下载连接
 * @param location 资源的本地文件位置，这是一个临时文件，delgate通知后会立即删除
 * @param error 错误信息
 */
- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishDownloadingToURL:(NSURL *)location error:(NSError *)error;

/*!
 * @brief 下载进度通知
 * @param downloadConnection 下载连接
 * @param bytesWritten 两次通知间的下载量
 * @param totalBytesWritten 已下载总量
 * @param totalBytesExpectedToWrite 期望下载总量（资源大小）
 */
- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

@end


/*********************************************************
 
    @class
        HTTPDownloadConnectionResumeConfiguration
 
    @abstract
        HTTP下载的断点续传配置信息
 
 *********************************************************/

@interface HTTPDownloadConnectionResumeConfiguration : NSObject

/*!
 * @brief 是否启用断点续传功能
 */
@property (nonatomic) BOOL enable;

/*!
 * @brief 断点信息存储器
 */
@property (nonatomic) HTTPConnectionResumeStorage *resumeStorage;

@end
