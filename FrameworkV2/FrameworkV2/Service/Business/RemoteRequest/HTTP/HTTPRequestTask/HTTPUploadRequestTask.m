//
//  HTTPUploadRequestTask.m
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPUploadRequestTask.h"
#import "HTTPUploadConnection.h"
#import "SharedHTTPSessionManager.h"

@interface HTTPUploadRequestTask () <HTTPUploadConnectionDelegate>

@property (nonatomic) HTTPUploadConnection *connection;

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

@end


@implementation HTTPUploadRequestTask

- (void)main
{
    NSURL *URL = self.URL ? self.URL : [NSURL URLWithString:@""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeout];
    
    request.HTTPMethod = @"POST";
    
    NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] init];
    
    if (self.uploadBody.contentType)
    {
        [headerFields setObject:self.uploadBody.contentType forKey:@"Content-Type"];
    }
    
    if ([self.headerFields count] > 0)
    {
        [headerFields addEntriesFromDictionary:self.headerFields];
    }
    
    if ([headerFields count] > 0)
    {
        request.allHTTPHeaderFields = headerFields;
    }
    
    HTTPConnectionInternetPassword *internetPassword = [[HTTPConnectionInternetPassword alloc] init];
    
    internetPassword.user = self.internetPassword.user;
    
    internetPassword.password = self.internetPassword.password;
    
    self.connection = [self.uploadBody uploadConnectionWithRequest:request session:[SharedHTTPSessionManager sharedInstance].defaultConfigurationSession];
    
    self.connection.internetPassword = internetPassword;
    
    self.connection.delegate = self;
    
    [self.connection start];
}

- (void)cancel
{
    [super cancel];
    
    self.connection.delegate = nil;
    
    [self.connection cancel];
    
    self.connection = nil;
}

- (void)HTTPUploadConnection:(HTTPUploadConnection *)uploadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data
{
    [self finishWithError:error response:response data:data];
}

- (void)HTTPUploadConnection:(HTTPUploadConnection *)uploadConnection didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPUploadRequestTask:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)])
        {
            [self.delegate HTTPUploadRequestTask:self didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
        }
    } onThread:self.notifyThread];
}

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPUploadRequestTask:didFinishWithError:response:data:)])
        {
            [self.delegate HTTPUploadRequestTask:self didFinishWithError:error response:response data:data];
        }
    } onThread:self.notifyThread];
}

@end
