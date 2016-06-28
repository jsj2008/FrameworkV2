//
//  StorageUnit.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "StorageUnit.h"
#import "DBCenter.h"
#import "ImageStorage.h"
#import "APPConfiguration.h"

@implementation StorageUnit

+ (StorageUnit *)sharedInstance
{
    static StorageUnit *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[StorageUnit alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    [[DBCenter sharedInstance] start];
    
    [ImageStorage sharedInstance].directory = [APPConfiguration sharedInstance].imageDirectory;
    
    [[ImageStorage sharedInstance] start];
}

- (void)stop
{
    [[ImageStorage sharedInstance] stop];
    
    [[DBCenter sharedInstance] stop];
}

@end
