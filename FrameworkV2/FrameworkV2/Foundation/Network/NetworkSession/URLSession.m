//
//  URLSession.m
//  FrameworkV2
//
//  Created by ww on 2017/3/31.
//  Copyright © 2017年 WW. All rights reserved.
//

#import "URLSession.h"
#import "NSURLSessionTask+Delegate.h"

@interface URLSession () <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate, NSURLSessionStreamDelegate>
{
    NSURLSession *_session;
}

- (void)operate:(void (^)(void))operation;

- (void)operate:(void (^)(void))operation onThread:(NSThread *)thread;

@property (nonatomic) NSThread *delegateThread;

@end


@implementation URLSession

@synthesize session = _session;

- (instancetype)initWithURLSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super init])
    {
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void)start
{
    self.delegateThread = [NSThread currentThread];
}

- (void)cancel
{
    self.delegate = nil;
    
    [self.session invalidateAndCancel];
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

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error;
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSession:didBecomeInvalidWithError:)])
        {
            [weakSelf.delegate URLSession:weakSelf didBecomeInvalidWithError:error];
        }
        
    } onThread:self.delegateThread];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler;
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
    
    NSURLCredential *credential = nil;
    
    if (self.credential)
    {
        credential = [self.credential credentialForChallenge:challenge];
        
        if (credential)
        {
            disposition = NSURLSessionAuthChallengeUseCredential;
        }
        else
        {
            disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
        }
    }
    else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        // 如果服务端用的是付费的公信机构颁发的证书，标准的HTTPS，NSURLSession会自动处理HTTPS的认证过程，不需要再外部干预。为确保万无一失，这里仍然强制信任服务端证书
        
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        disposition = NSURLSessionAuthChallengeUseCredential;
    }
    else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate])
    {
        disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
    }
    else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNTLM])
    {
        disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
    }
    else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNegotiate])
    {
        disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
    }
    
    if (completionHandler)
    {
        completionHandler(disposition, credential);
    }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    __weak typeof(self) weakSelf = self;
    
    [self operate:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(URLSessionDidFinishEventsForBackgroundSession:)])
        {
            [weakSelf.delegate URLSessionDidFinishEventsForBackgroundSession:weakSelf];
        }
        
    } onThread:self.delegateThread];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler
{
    [task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    [task didReceiveChallenge:challenge completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler
{
    [task needNewBodyStream:completionHandler];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    [task didCompleteWithError:error];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    [dataTask didBecomeDownloadTask:downloadTask];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
    [dataTask didBecomeStreamTask:streamTask];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler
{
    [dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    [downloadTask didFinishDownloadingToURL:location];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    [downloadTask didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
}

#pragma mark - NSURLSessionStreamDelegate

- (void)URLSession:(NSURLSession *)session readClosedForStreamTask:(NSURLSessionStreamTask *)streamTask
{
    [streamTask didCloseRead];
}

- (void)URLSession:(NSURLSession *)session writeClosedForStreamTask:(NSURLSessionStreamTask *)streamTask
{
    [streamTask didCloseWrite];
}

- (void)URLSession:(NSURLSession *)session betterRouteDiscoveredForStreamTask:(NSURLSessionStreamTask *)streamTask
{
    [streamTask didDiscoverBetterRoute];
}

- (void)URLSession:(NSURLSession *)session streamTask:(NSURLSessionStreamTask *)streamTask didBecomeInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    [streamTask didBecomeInputStream:inputStream outputStream:outputStream];
}

@end


@implementation URLSessionCredential

- (NSURLCredential *)credentialForChallenge:(NSURLAuthenticationChallenge *)challenge
{
    return nil;
}

@end
