//
//  HTTPDataRequestTask.m
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPDataRequestTask.h"
#import "HTTPDataConnection.h"
#import "SharedHTTPSessionManager.h"

@interface HTTPDataRequestTask () <HTTPDataConnectionDelegate>

@property (nonatomic) HTTPDataConnection *connection;

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

@end


@implementation HTTPDataRequestTask

- (instancetype)init
{
    if (self = [super init])
    {
        self.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
        self.cacheStorable = YES;
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super initWithURL:URL])
    {
        self.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        
        self.cacheStorable = YES;
    }
    
    return self;
}

- (void)run
{
    NSURL *URL = self.URL ? self.URL : [NSURL URLWithString:@""];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:self.cachePolicy timeoutInterval:self.timeout];
    
    request.HTTPMethod = @"GET";
    
    request.allHTTPHeaderFields = self.headerFields;
    
    HTTPConnectionInternetPassword *internetPassword = [[HTTPConnectionInternetPassword alloc] init];
    
    internetPassword.user = self.internetPassword.user;
    
    internetPassword.password = self.internetPassword.password;
    
    self.connection = [[HTTPDataConnection alloc] initWithRequest:request session:[SharedHTTPSessionManager sharedInstance].defaultConfigurationSession];
    
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

- (void)HTTPDataConnection:(HTTPDataConnection *)dataConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data
{
    [self finishWithError:error response:response data:data];
}

- (NSURLSessionResponseDisposition)HTTPDataConnection:(HTTPDataConnection *)dataConnection dispositionForResponse:(NSURLResponse *)response
{
    return NSURLSessionResponseAllow;
}

- (NSCachedURLResponse *)HTTPDataConnection:(HTTPDataConnection *)dataConnection willCacheResponse:(NSCachedURLResponse *)proposedResponse
{
    return self.cacheStorable ? proposedResponse : nil;
}

- (void)finishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPDataRequestTask:didFinishWithError:response:data:)])
        {
            [self.delegate HTTPDataRequestTask:self didFinishWithError:error response:response data:data];
        }
    } onThread:self.notifyThread];
}

@end
