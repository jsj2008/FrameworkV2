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
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionTask:willPerformHTTPRedirection:newRequest:completionHandler:)])
        {
            [self.delegate URLSessionTask:self willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionTask:didReceiveChallenge:completionHandler:)])
        {
            [self.delegate URLSessionTask:self didReceiveChallenge:challenge completionHandler:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionTask:needNewBodyStream:)])
        {
            [self.delegate URLSessionTask:self needNewBodyStream:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionTask:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)])
        {
            [self.delegate URLSessionTask:self didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }
        
    } onThread:self.delegateThread];
}

- (void)didCompleteWithError:(NSError *)error
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionTask:didCompleteWithError:)])
        {
            [self.delegate URLSessionTask:self didCompleteWithError:error];
        }
        
    } onThread:self.delegateThread];
}

#pragma mark - dataTask

- (void)didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDataTask:didReceiveResponse:completionHandler:)])
        {
            [self.delegate URLSessionDataTask:self didReceiveResponse:response completionHandler:completionHandler];
        }
        
    } onThread:self.delegateThread];
}

- (void)didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDataTask:didBecomeDownloadTask:)])
        {
            [self.delegate URLSessionDataTask:self didBecomeDownloadTask:downloadTask];
        }
        
    } onThread:self.delegateThread];
}

- (void)didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDataTask:didBecomeStreamTask:)])
        {
            [self.delegate URLSessionDataTask:self didBecomeStreamTask:streamTask];
        }
        
    } onThread:self.delegateThread];
}

- (void)didReceiveData:(NSData *)data
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDataTask:didReceiveData:)])
        {
            [self.delegate URLSessionDataTask:self didReceiveData:data];
        }
        
    } onThread:self.delegateThread];
}

- (void)willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * cachedResponse))completionHandler
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDataTask:willCacheResponse:completionHandler:)])
        {
            [self.delegate URLSessionDataTask:self willCacheResponse:proposedResponse completionHandler:completionHandler];
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
    
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDownloadTask:didFinishDownloadingToURL:error:)])
        {
            [self.delegate URLSessionDownloadTask:self didFinishDownloadingToURL:newLocation error:error];
        }
        
        [fileManager removeItemAtURL:newLocation error:nil];
        
    } onThread:self.delegateThread];
}

- (void)didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDownloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
        {
            [self.delegate URLSessionDownloadTask:self didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }
        
    } onThread:self.delegateThread];
}

- (void)didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionDownloadTask:didResumeAtOffset:expectedTotalBytes:)])
        {
            [self.delegate URLSessionDownloadTask:self didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
        }
        
    } onThread:self.delegateThread];
}

#pragma mark - streamTask

- (void)didCloseRead
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionStreamTaskDidCloseRead:)])
        {
            [self.delegate URLSessionStreamTaskDidCloseRead:self];
        }
        
    } onThread:self.delegateThread];
}

- (void)didCloseWrite
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionStreamTaskDidCloseWrite:)])
        {
            [self.delegate URLSessionStreamTaskDidCloseWrite:self];
        }
        
    } onThread:self.delegateThread];
}

- (void)didDiscoverBetterRoute
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionStreamTaskDidDiscoverBetterRoute:)])
        {
            [self.delegate URLSessionStreamTaskDidDiscoverBetterRoute:self];
        }
        
    } onThread:self.delegateThread];
}

- (void)didBecomeInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    [self operate:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(URLSessionStreamTask:didBecomeInputStream:outputStream:)])
        {
            [self.delegate URLSessionStreamTask:self didBecomeInputStream:inputStream outputStream:outputStream];
        }
        
    } onThread:self.delegateThread];
}

@end
