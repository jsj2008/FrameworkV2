//
//  HTTPDataConnection.m
//  Test1
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPDataConnection.h"
#import "HTTPDownloadConnection.h"

@interface HTTPDataConnection ()

@property (nonatomic) NSURLSessionDataTask *dataTask;

@property (nonatomic) NSMutableData *data;

@end


@implementation HTTPDataConnection

- (instancetype)initWithURLSessionDataTask:(NSURLSessionDataTask *)task
{
    if (self = [super init])
    {
        self.dataTask = task;
        
        self.dataTask.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    if (self = [super initWithRequest:request session:session])
    {
        self.dataTask = [session.session dataTaskWithRequest:request];
        
        self.dataTask.delegate = self;
    }
    
    return self;
}

- (NSURLRequest *)originalRequest
{
    return self.dataTask.originalRequest;
}

- (NSURLRequest *)currentRequest
{
    return self.dataTask.currentRequest;
}

- (void)start
{
    self.data = [[NSMutableData alloc] init];
    
    self.dataTask.delegateThread = [NSThread currentThread];
    
    [self.dataTask resume];
}

- (void)cancel
{
    self.delegate = nil;
    
    self.data = nil;
    
    self.dataTask.delegate = nil;
    
    [self.dataTask cancel];
}

- (void)URLSessionTask:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDataConnection:didFinishWithError:response:data:)])
    {
        [self.delegate HTTPDataConnection:self didFinishWithError:error response:([task.response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)(task.response) : nil) data:self.data];
    }
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDataConnection:willCacheResponse:)])
    {
        if (completionHandler)
        {
            completionHandler([self.delegate HTTPDataConnection:self willCacheResponse:proposedResponse]);
        }
    }
    else if ([[dataTask.currentRequest.HTTPMethod lowercaseString] isEqualToString:@"get"])
    {
        if (completionHandler)
        {
            completionHandler(proposedResponse);
        }
    }
    else
    {
        if (completionHandler)
        {
            completionHandler(nil);
        }
    }
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDataConnection:dispositionForResponse:)])
    {
        disposition = [self.delegate HTTPDataConnection:self dispositionForResponse:response];
    }
    
    if (disposition == NSURLSessionResponseBecomeStream)
    {
        disposition = NSURLSessionResponseCancel;
    }
    
    if (completionHandler)
    {
        completionHandler(disposition);
    }
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDataConnection:didBecomeDownloadConnection:)])
    {
        HTTPDownloadConnection *downloadConnection = [[HTTPDownloadConnection alloc] initWithURLSessionDownloadTask:downloadTask];
        
        [self.delegate HTTPDataConnection:self didBecomeDownloadConnection:downloadConnection];
    }
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
    
}

@end
