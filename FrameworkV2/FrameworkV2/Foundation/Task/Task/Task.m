//
//  Task.m
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "Task.h"

@implementation Task

- (instancetype)init
{
    if (self = [super init])
    {
        _status = TaskPrepared;
    }
    
    return self;
}

- (void)start
{
    _status = TaskRunning;
    
    _runningThread = [NSThread currentThread];
    
    [self main];
}

- (void)main
{
    
}

- (void)cancel
{
    _status = TaskFinished;
}

@end


@implementation Task (Notification)

- (void)notify:(void (^)(void))notification
{
    if (notification)
    {
        notification();
    }
}

- (void)notify:(void (^)(void))notification onThread:(NSThread *)thread
{
    [self performSelector:@selector(notify:) onThread:thread ? thread : [NSThread currentThread] withObject:notification waitUntilDone:NO];
}

@end
