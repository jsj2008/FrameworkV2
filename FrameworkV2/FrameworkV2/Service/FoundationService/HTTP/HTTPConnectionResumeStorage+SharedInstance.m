//
//  HTTPConnectionResumeStorage+SharedInstance.m
//  FrameworkV1
//
//  Created by ww on 16/5/3.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPConnectionResumeStorage+SharedInstance.h"

@implementation HTTPConnectionResumeStorage (SharedInstance)

+ (HTTPConnectionResumeStorage *)sharedInstance
{
    static HTTPConnectionResumeStorage *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[HTTPConnectionResumeStorage alloc] init];
        }
    });
    
    return instance;
}

@end
