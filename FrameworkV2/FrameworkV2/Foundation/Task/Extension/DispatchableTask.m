//
//  DispatchableTask.m
//  Test
//
//  Created by ww on 16/6/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "DispatchableTask.h"

@implementation DispatchableTask

- (instancetype)init
{
    if (self = [super init])
    {
        _syncTaskDispatcher = [[SyncTaskDispatcher alloc] init];
        
        _asyncTaskDispatcher = [[AsyncTaskDispatcher alloc] init];
    }
    
    return self;
}

- (void)cancel
{
    [super cancel];
    
    [_syncTaskDispatcher cancel];
    
    _syncTaskDispatcher = nil;
    
    [_asyncTaskDispatcher cancel];
    
    _asyncTaskDispatcher = nil;
}

@end
