//
//  DBCenter.m
//  FrameworkV1
//
//  Created by ww on 16/5/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "DBCenter.h"

@implementation DBCenter

+ (DBCenter *)sharedInstance
{
    static DBCenter *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[DBCenter alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    
}

- (void)stop
{
    
}

@end
