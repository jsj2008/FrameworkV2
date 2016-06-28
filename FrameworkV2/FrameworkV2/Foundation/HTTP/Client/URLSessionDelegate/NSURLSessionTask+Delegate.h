//
//  NSURLSessionTask+Delegate.h
//  Test1
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLSessionTaskDelegate;


/*********************************************************
 
    @category
        NSURLSessionTask (Delegate)
 
    @abstract
        NSURLSessionTask的delegate类别扩展，用于将NSURLSession的代理通知转换成NSURLSessionTask的代理通知
 
    @discussion
        1，delegate扩展使得相应的网络通知能够转发到不同的对象
        2，扩展的方法内部实现了跨线程的通知，可以避免线程切换带来的各种问题
        3，原本应当将不同类型的Task的通知单独做成对应的类别扩展，但是，NSURLSession的delegate通知中调用dataTask，downloadTask，uploadTask的对应通知方法都会报错（找不到对象方法），这是一个恶心的问题，因此将所有的Task的通知都归入NSURLSessionTask类别扩展中，这样不会报错
        4，扩展方法和通知方法都与NSURLSession的delegate通知对应，具体注释参照NSURLSession的对应方法
 
 *********************************************************/

@interface NSURLSessionTask (Delegate)

/*!
 * @brief 代理对象
 */
@property (nonatomic) id<URLSessionTaskDelegate> delegate;

/*!
 * @brief 代理通知的线程，所有的delegate通知都将在该线程进行
 */
@property (nonatomic) NSThread *delegateThread;

/*!
 * @brief 执行指定操作
 * @param operation 操作块
 */
- (void)operate:(void (^)(void))operation;

/*!
 * @brief 在指定线程执行指定操作
 * @param operation 操作块
 * @param thread 操作线程
 */
- (void)operate:(void (^)(void))operation onThread:(NSThread *)thread;

// task

- (void)willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler;

- (void)didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler;

- (void)needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler;

- (void)didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

- (void)didCompleteWithError:(NSError *)error;

// dataTask

- (void)didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;

- (void)didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask;

- (void)didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask;

- (void)didReceiveData:(NSData *)data;

- (void)willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * cachedResponse))completionHandler;

// downloadTask

- (void)didFinishDownloadingToURL:(NSURL *)location;

- (void)didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

- (void)didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes;

// streamTask

- (void)didCloseRead;

- (void)didCloseWrite;

- (void)didDiscoverBetterRoute;

- (void)didBecomeInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;

@end


/*********************************************************
 
    @protocol
        URLSessionTaskDelegate
 
    @abstract
        NSURLSessionTask的delegate通知协议，具体注释参照NSURLSession的对应方法
 
 *********************************************************/

@protocol URLSessionTaskDelegate <NSObject>

@optional

// task

- (void)URLSessionTask:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler;

- (void)URLSessionTask:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler;

- (void)URLSessionTask:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler;

- (void)URLSessionTask:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

- (void)URLSessionTask:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;

// dataTask

- (void)URLSessionDataTask:(NSURLSessionTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler;

- (void)URLSessionDataTask:(NSURLSessionTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask;

- (void)URLSessionDataTask:(NSURLSessionTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask;

- (void)URLSessionDataTask:(NSURLSessionTask *)dataTask didReceiveData:(NSData *)data;

- (void)URLSessionDataTask:(NSURLSessionTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * cachedResponse))completionHandler;

// downloadTask

- (void)URLSessionDownloadTask:(NSURLSessionTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location error:(NSError *)error;

- (void)URLSessionDownloadTask:(NSURLSessionTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

- (void)URLSessionDownloadTask:(NSURLSessionTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes;

// streamTask

- (void)URLSessionStreamTaskDidCloseRead:(NSURLSessionTask *)streamTask;

- (void)URLSessionStreamTaskDidCloseWrite:(NSURLSessionTask *)streamTask;

- (void)URLSessionStreamTaskDidDiscoverBetterRoute:(NSURLSessionTask *)streamTask;

- (void)URLSessionStreamTask:(NSURLSessionTask *)streamTask didBecomeInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;

@end
