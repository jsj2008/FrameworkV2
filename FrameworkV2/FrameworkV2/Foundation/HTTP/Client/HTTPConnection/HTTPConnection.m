//
//  HTTPConnection.m
//  Test1
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnection.h"

@implementation HTTPConnection

- (instancetype)initWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    if (self = [super init])
    {
        _originalRequest = [request copy];
        
        _currentRequest = [request copy];
        
        _session = session;
    }
    
    return self;
}

- (void)start
{
    
}

- (void)cancel
{
    
}

- (void)URLSessionTask:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    _currentRequest = request;
    
    if (completionHandler)
    {
        completionHandler(request);
    }
}

- (void)URLSessionTask:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
    
    NSURLCredential *credential = nil;
    
    if (challenge.previousFailureCount == 0 && self.internetPassword.user && self.internetPassword.password)
    {
        credential = [NSURLCredential credentialWithUser:self.internetPassword.user password:self.internetPassword.password persistence:NSURLCredentialPersistenceForSession];
        
        disposition = NSURLSessionAuthChallengeUseCredential;
    }
    
    if (completionHandler)
    {
        completionHandler(disposition, credential);
    }
}

- (void)URLSessionTask:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler
{
    if (completionHandler)
    {
        completionHandler(nil);
    }
}

- (void)URLSessionTask:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    
}

- (void)URLSessionTask:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}

@end


@implementation HTTPConnectionInternetPassword

@end
