//
//  HTTPUploadConnection.m
//  Test1
//
//  Created by ww on 16/4/11.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPUploadConnection.h"

@interface HTTPUploadConnection ()

@property (nonatomic) NSURLSessionUploadTask *uploadTask;

@property (nonatomic) HTTPConnectionInputStream *stream;

@property (nonatomic) BOOL streamUsed;

@property (nonatomic) NSMutableData *data;

@end


@implementation HTTPUploadConnection

- (instancetype)initWithURLSessionUploadTask:(NSURLSessionUploadTask *)task
{
    if (self = [super init])
    {
        self.uploadTask = task;
        
        self.uploadTask.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request fromData:(NSData *)data session:(HTTPSession *)session
{
    if (self = [super initWithRequest:request session:session])
    {
        // - (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData方法要求bodyData不能为nil
        // 为nil时，请求会被直接结束并返回cancel的错误码
        
        self.uploadTask = [session.session uploadTaskWithRequest:request fromData:data ? data : [NSData data]];
        
        self.uploadTask.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request fromFile:(NSURL *)file session:(HTTPSession *)session
{
    if (self = [super initWithRequest:request session:session])
    {
        // - (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL方法要求fileURL不能为nil
        // 为nil或无效文件URL时，请求会被直接结束并返回cancel的错误码
        
        if ([file checkResourceIsReachableAndReturnError:nil])
        {
            self.uploadTask = [session.session uploadTaskWithRequest:request fromFile:file];
        }
        else
        {
            self.uploadTask = [session.session uploadTaskWithRequest:request fromData:[NSData data]];
        }
        
        self.uploadTask.delegate = self;
    }
    
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request fromStream:(HTTPConnectionInputStream *)stream session:(HTTPSession *)session
{
    if (self = [super initWithRequest:request session:session])
    {
        self.stream = stream;
        
        self.uploadTask = [session.session uploadTaskWithStreamedRequest:request];
        
        self.uploadTask.delegate = self;
    }
    
    return self;
}

- (NSURLRequest *)originalRequest
{
    return self.uploadTask.originalRequest;
}

- (NSURLRequest *)currentRequest
{
    return self.uploadTask.currentRequest;
}

- (void)start
{
    self.data = [[NSMutableData alloc] init];
    
    self.streamUsed = NO;
    
    self.uploadTask.delegateThread = [NSThread currentThread];
    
    [self.uploadTask resume];
}

- (void)cancel
{
    self.delegate = nil;
    
    self.data = nil;
    
    self.uploadTask.delegate = nil;
    
    [self.uploadTask cancel];
}

- (void)URLSessionTask:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPUploadConnection:didFinishWithError:response:data:)])
    {
        [self.delegate HTTPUploadConnection:self didFinishWithError:error response:([task.response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)(task.response) : nil) data:self.data];
    }
}

- (void)URLSessionTask:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *))completionHandler
{
    HTTPConnectionInputStream *stream = self.streamUsed ? [self.stream copy] : self.stream;
    
    [stream open];
    
    self.streamUsed = YES;
    
    completionHandler(stream);
}

- (void)URLSessionTask:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPUploadConnection:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)])
    {
        [self.delegate HTTPUploadConnection:self didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
    }
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler
{
    completionHandler(nil);
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    
}

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
    
}

@end
