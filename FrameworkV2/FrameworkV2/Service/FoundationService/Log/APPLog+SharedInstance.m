//
//  APPLog+SharedInstance.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "APPLog+SharedInstance.h"

@implementation APPLog (SharedInstance)

+ (APPLog *)sharedInstance
{
    static APPLog *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[APPLog alloc] init];
        }
    });
    
    return instance;
}

@end
