//
//  NSURLSessionTask+Delegate.m
//  Test1
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "NSURLSessionTask+Delegate.h"
#import <objc/runtime.h>

static const char kNSURLSessionTaskPropertyKey_Delegate[] = "delegate";

static const char kNSURLSessionTaskPropertyKey_DelegateThread[] = "delegateThread";

static NSInteger flag = 0;


@implementation NSURLSessionTask (Delegate)

- (void)setDelegate:(id<URLSessionTaskDelegate>)delegate
{
    objc_setAssociatedObject(self, kNSURLSessionTaskPropertyKey_Delegate, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<URLSessionTaskDelegate>)delegate
{
    return objc_getAssociatedObject(self, kNSURLSessionTaskPropertyKey_Delegate);
}

- (void)setDelegateThread:(NSThread *)delegateThread
{
    objc_setAssociatedObject(self, kNSURLSessionTaskPropertyKey_DelegateThread, delegateThread, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSThread *)delegateThread
{
    return objc_getAssociatedObject(self, kNSURLSessionTaskPropertyKey_DelegateThread);
}

- (void)operate:(void (^)(void))operation
{
    if (operation)
    {
        operation();
    }
}

- (void)operate:(void (^)(void))operation onThread:(NSThread *)thread
{
    [self performSelector:@selector(operate:) onThread:thread withObject:operation waitUntilDone:NO];
}

#pragma mark - task

- (void)willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionTask:willPerformHTTPRedirection:newRequest:completionHandler:)])
        {
            [weakSelf.delegate URLSessionTask:weakSelf willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionTask:didReceiveChallenge:completionHandler:)])
        {
            [weakSelf.delegate URLSessionTask:weakSelf didReceiveChallenge:challenge completionHandler:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionTask:needNewBodyStream:)])
        {
            [weakSelf.delegate URLSessionTask:weakSelf needNewBodyStream:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionTask:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)])
        {
            [weakSelf.delegate URLSessionTask:weakSelf didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }
        
    } onThread:self.delegateThread];
}

- (void)didCompleteWithError:(NSError *)error
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionTask:didCompleteWithError:)])
        {
            [weakSelf.delegate URLSessionTask:weakSelf didCompleteWithError:error];
        }
        
    } onThread:self.delegateThread];
}

#pragma mark - dataTask

- (void)didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDataTask:didReceiveResponse:completionHandler:)])
        {
            [weakSelf.delegate URLSessionDataTask:weakSelf didReceiveResponse:response completionHandler:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDataTask:didBecomeDownloadTask:)])
        {
            [weakSelf.delegate URLSessionDataTask:weakSelf didBecomeDownloadTask:downloadTask];
        }
        
    } onThread:self.delegateThread];
}

- (void)didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDataTask:didBecomeStreamTask:)])
        {
            [weakSelf.delegate URLSessionDataTask:weakSelf didBecomeStreamTask:streamTask];
        }
        
    } onThread:self.delegateThread];
}

- (void)didReceiveData:(NSData *)data
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDataTask:didReceiveData:)])
        {
            [weakSelf.delegate URLSessionDataTask:weakSelf didReceiveData:data];
        }
        
    } onThread:self.delegateThread];
}

- (void)willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * cachedResponse))completionHandler
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDataTask:willCacheResponse:completionHandler:)])
        {
            [weakSelf.delegate URLSessionDataTask:weakSelf willCacheResponse:proposedResponse completionHandler:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

#pragma mark - downloadTask

- (void)didFinishDownloadingToURL:(NSURL *)location
{
    flag ++;
    
    NSError *error = nil;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f%ld", [[NSDate date] timeIntervalSince1970], (long)flag]];
    
    NSURL *newLocation = [NSURL fileURLWithPath:path];
    
    [fileManager moveItemAtURL:location toURL:newLocation error:&error];
    
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDownloadTask:didFinishDownloadingToURL:error:)])
        {
            [weakSelf.delegate URLSessionDownloadTask:weakSelf didFinishDownloadingToURL:newLocation error:error];
        }
        
        [fileManager removeItemAtURL:newLocation error:nil];
        
    } onThread:self.delegateThread];
}

- (void)didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDownloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
        {
            [weakSelf.delegate URLSessionDownloadTask:weakSelf didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }
        
    } onThread:self.delegateThread];
}

- (void)didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDownloadTask:didResumeAtOffset:expectedTotalBytes:)])
        {
            [weakSelf.delegate URLSessionDownloadTask:weakSelf didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
        }
        
    } onThread:self.delegateThread];
}

#pragma mark - streamTask

- (void)didCloseRead
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionStreamTaskDidCloseRead:)])
        {
            [weakSelf.delegate URLSessionStreamTaskDidCloseRead:weakSelf];
        }
        
    } onThread:self.delegateThread];
}

- (void)didCloseWrite
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionStreamTaskDidCloseWrite:)])
        {
            [weakSelf.delegate URLSessionStreamTaskDidCloseWrite:weakSelf];
        }
        
    } onThread:self.delegateThread];
}

- (void)didDiscoverBetterRoute
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionStreamTaskDidDiscoverBetterRoute:)])
        {
            [weakSelf.delegate URLSessionStreamTaskDidDiscoverBetterRoute:weakSelf];
        }
        
    } onThread:self.delegateThread];
}

- (void)didBecomeInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionStreamTask:didBecomeInputStream:outputStream:)])
        {
            [weakSelf.delegate URLSessionStreamTask:weakSelf didBecomeInputStream:inputStream outputStream:outputStream];
        }
        
    } onThread:self.delegateThread];
}

@end
