//
//  HTTPDownloadConnection.m
//  Test1
//
//  Created by ww on 16/4/11.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPDownloadConnection.h"

@interface HTTPDownloadConnection ()

@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@property (nonatomic) HTTPDownloadConnectionResumeConfiguration *resumeConfiguration;

@end


@implementation HTTPDownloadConnection

- (instancetype)initWithURLSessionDownloadTask:(NSURLSessionDownloadTask *)task
{
    if (self = [super init])
    {
        self.downloadTask = task;
        
        self.downloadTask.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    if (self = [super initWithRequest:request session:session])
    {
        self.downloadTask = [session.session downloadTaskWithRequest:request];
        
        self.downloadTask.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request resumeConfiguration:(HTTPDownloadConnectionResumeConfiguration *)resumeConfiguration session:(HTTPSession *)session
{
    if (self = [super initWithRequest:request session:session])
    {
        self.resumeConfiguration = resumeConfiguration;
        
        NSData *resumeData = nil;
        
        if (resumeConfiguration.enable && resumeConfiguration.resumeStorage)
        {
            resumeData = [resumeConfiguration.resumeStorage resumeDataForRequest:request];
        }
        
        if ([resumeData length] > 0)
        {
            self.downloadTask = [session.session downloadTaskWithResumeData:resumeData];
        }
        else
        {
            self.downloadTask = [session.session downloadTaskWithRequest:request];
        }
        
        self.downloadTask.delegate = self;
    }
    
    return self;
}

- (NSURLRequest *)originalRequest
{
    return self.downloadTask.originalRequest;
}

- (NSURLRequest *)currentRequest
{
    return self.downloadTask.currentRequest;
}

- (void)start
{
    self.downloadTask.delegateThread = [NSThread currentThread];
    
    [self.downloadTask resume];
}

- (void)cancel
{
    self.delegate = nil;
    
    self.downloadTask.delegate = nil;
    
    if (self.resumeConfiguration.enable && self.resumeConfiguration.resumeStorage)
    {
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            
            [self.resumeConfiguration.resumeStorage saveResumeData:resumeData forRequest:self.originalRequest];
        }];;
    }
    else
    {
        [self.downloadTask cancel];
    }
}

- (void)pause
{
    [self.downloadTask suspend];
}

- (void)resume
{
    [self.downloadTask resume];
}

- (void)URLSessionTask:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadConnection:didFinishWithError:response:)])
    {
        [self.delegate HTTPDownloadConnection:self didFinishWithError:error response:([task.response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)(task.response) : nil)];
    }
}

- (void)URLSessionDownloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location error:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadConnection:didFinishDownloadingToURL:error:)])
    {
        [self.delegate HTTPDownloadConnection:self didFinishDownloadingToURL:location error:error];
    }
}

- (void)URLSessionDownloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadConnection:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate HTTPDownloadConnection:self didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (void)URLSessionDownloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadConnection:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate HTTPDownloadConnection:self didWriteData:fileOffset totalBytesWritten:fileOffset totalBytesExpectedToWrite:expectedTotalBytes];
    }
}

@end


@implementation HTTPDownloadConnectionResumeConfiguration

@end
