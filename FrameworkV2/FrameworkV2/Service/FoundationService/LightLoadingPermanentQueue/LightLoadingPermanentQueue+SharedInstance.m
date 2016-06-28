//
//  LightLoadingPermanentQueue+SharedInstance.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "LightLoadingPermanentQueue+SharedInstance.h"

@implementation LightLoadingPermanentQueue (SharedInstance)

+ (LightLoadingPermanentQueue *)sharedInstance
{
    static LightLoadingPermanentQueue *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[LightLoadingPermanentQueue alloc] init];
        }
    });
    
    return instance;
}

@end
