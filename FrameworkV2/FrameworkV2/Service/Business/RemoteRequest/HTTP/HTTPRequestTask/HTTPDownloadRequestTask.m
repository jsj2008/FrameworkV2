//
//  HTTPDownloadRequestTask.m
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPDownloadRequestTask.h"
#import "HTTPDownloadConnection.h"
#import "SharedHTTPSessionManager.h"
#import "HTTPConnectionResumeStorage+SharedInstance.h"

@interface HTTPDownloadRequestTask () <HTTPDownloadConnectionDelegate>

@property (nonatomic) HTTPDownloadConnection *connection;

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response;

@end


@implementation HTTPDownloadRequestTask

- (void)run
{
    NSURL *URL = self.URL ? self.URL : [NSURL URLWithString:@""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.timeout];
    
    request.HTTPMethod = @"GET";
    
    request.allHTTPHeaderFields = self.headerFields;
    
    HTTPConnectionInternetPassword *internetPassword = [[HTTPConnectionInternetPassword alloc] init];
    
    internetPassword.user = self.internetPassword.user;
    
    internetPassword.password = self.internetPassword.password;
    
    HTTPDownloadConnectionResumeConfiguration *configuration = [[HTTPDownloadConnectionResumeConfiguration alloc] init];
    
    if (self.resumable)
    {
        configuration.enable = YES;
        
        configuration.resumeStorage = [HTTPConnectionResumeStorage sharedInstance];
    }
    else
    {
        configuration.enable = NO;
    }
    
    self.connection = [[HTTPDownloadConnection alloc] initWithRequest:request resumeConfiguration:configuration session:[SharedHTTPSessionManager sharedInstance].defaultConfigurationSession];
    
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

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response
{
    [self finishWithError:error response:response];
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishDownloadingToURL:(NSURL *)location error:(NSError *)error
{
    if (error)
    {
        [self finishWithError:error response:nil];
    }
    else
    {
        NSError *error = nil;
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if (![fileManager moveItemAtURL:location toURL:self.resourceURL error:&error])
        {
            [self finishWithError:error response:nil];
        }
    }
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadRequestTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
        {
            [self.delegate HTTPDownloadRequestTask:self didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }
    } onThread:self.notifyThread];
}

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDownloadRequestTask:didFinishWithError:response:)])
        {
            [self.delegate HTTPDownloadRequestTask:self didFinishWithError:error response:response];
        }
    } onThread:self.notifyThread];
}

@end
