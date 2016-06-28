//
//  FoundationServiceUnit.m
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "FoundationServiceUnit.h"
#import "NSObject+ThreadOperation.h"

#import <libxml2/libxml/tree.h>

#import "APPConfiguration.h"

#import "APPLog+SharedInstance.h"

#import "NetworkManager.h"

#import "LightLoadingPermanentQueue+SharedInstance.h"

@implementation FoundationServiceUnit

+ (FoundationServiceUnit *)sharedInstance
{
    static FoundationServiceUnit *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[FoundationServiceUnit alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    // 初始化Libxml
    xmlInitParser();
    
    // 日志系统
    
    [APPLog sharedInstance].logFileDirectory = [APPConfiguration sharedInstance].appLogDirectory;
    
    [APPLog sharedInstance].enableNSLog = YES;
    
    [APPLog sharedInstance].enableFileLog = YES;
    
    [[APPLog sharedInstance] start];
    
    // 轻载常驻队列
    [[LightLoadingPermanentQueue sharedInstance] start];
    
    // HTTP
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [NSURLCache sharedURLCache].diskCapacity = 100 * 1024 * 1024;
    
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        // 网络状态
        [[NetworkManager sharedInstance] start];;
    }];
}

- (void)stop
{
    NSThread *thread = [NSThread currentThread];
    
    [[LightLoadingPermanentQueue sharedInstance] addBlock:^{
        
        [[NetworkManager sharedInstance] stop];
        
        [self operate:^{
            
            [[LightLoadingPermanentQueue sharedInstance] stop];
            
            [[APPLog sharedInstance] stop];
            
        } onThread:thread];
    }];
}

@end
