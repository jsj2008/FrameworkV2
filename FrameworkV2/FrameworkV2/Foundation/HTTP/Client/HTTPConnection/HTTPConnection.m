//
//  HTTPConnection.m
//  Test1
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnection.h"

@interface HTTPConnection ()
{
    NSURLRequest *_request;
    
    HTTPSession *_session;
}

@end


@implementation HTTPConnection

@synthesize session = _session;

- (instancetype)initWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    if (self = [super init])
    {
        _request = [request copy];
        
        _session = session;
    }
    
    return self;
}

- (NSURLRequest *)originalRequest
{
    return _request;
}

- (NSURLRequest *)currentRequest
{
    return _request;
}

- (void)start
{
    
}

- (void)cancel
{
    
}

- (void)URLSessionTask:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    completionHandler(request);
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
    
    completionHandler(disposition, credential);
}

- (void)URLSessionTask:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * bodyStream))completionHandler
{
    completionHandler(nil);
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
