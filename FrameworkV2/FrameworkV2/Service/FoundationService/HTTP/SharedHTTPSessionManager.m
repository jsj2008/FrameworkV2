//
//  SharedHTTPSessionManager.m
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SharedHTTPSessionManager.h"

@interface SharedHTTPSessionManager ()

- (NSURLSessionConfiguration *)defaultConfiguration;

- (NSURLSessionConfiguration *)ephemeralConfiguration;

@end


@implementation SharedHTTPSessionManager

+ (SharedHTTPSessionManager *)sharedInstance
{
    static SharedHTTPSessionManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[SharedHTTPSessionManager alloc] init];
            
            instance.defaultConfigurationSession = [[HTTPSession alloc] initWithURLSessionConfiguration:[instance defaultConfiguration]];
            
            instance.ephemeralConfigurationSession = [[HTTPSession alloc] initWithURLSessionConfiguration:[instance ephemeralConfiguration]];
        }
    });
    
    return instance;
}

- (void)URLSession:(URLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    // 系统错误返回error，取消session返回的error为nil
    if (error)
    {
        if (session == self.defaultConfigurationSession)
        {
            self.defaultConfigurationSession = [[HTTPSession alloc] initWithURLSessionConfiguration:[self defaultConfiguration]];
        }
    }
}

- (void)URLSessionDidFinishEventsForBackgroundSession:(URLSession *)session
{
    
}

- (NSURLSessionConfiguration *)defaultConfiguration
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.URLCache = [NSURLCache sharedURLCache];
    
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    configuration.HTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
    
    configuration.HTTPShouldSetCookies = YES;
    
    configuration.URLCredentialStorage = [NSURLCredentialStorage sharedCredentialStorage];
    
    return configuration;
}

- (NSURLSessionConfiguration *)ephemeralConfiguration
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    
    return configuration;
}

@end
