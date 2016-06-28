//
//  APPConfiguration.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "APPConfiguration.h"

@implementation APPConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        self.appLogDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"APPLog"];
        
        self.imageDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Image"];
    }
    
    return self;
}

+ (APPConfiguration *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    static APPConfiguration *instance = nil;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[APPConfiguration alloc] init];
    });
    
    return instance;
}

@end
