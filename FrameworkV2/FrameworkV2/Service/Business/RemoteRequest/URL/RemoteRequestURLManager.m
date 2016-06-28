//
//  RemoteRequestURLManager.m
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "RemoteRequestURLManager.h"

@implementation RemoteRequestURLManager

+ (RemoteRequestURLManager *)sharedInstance
{
    static RemoteRequestURLManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[RemoteRequestURLManager alloc] init];
        }
    });
    
    return instance;
}

@end
