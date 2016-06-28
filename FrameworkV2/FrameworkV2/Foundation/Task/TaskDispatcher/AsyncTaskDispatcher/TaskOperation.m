//
//  TaskOperation.m
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "TaskOperation.h"
#import "Task+Operation.h"

@implementation TaskOperation

- (instancetype)initWithTask:(Task *)task
{
    if (self = [super init])
    {
        _task = task;
    }
    
    return self;
}

- (void)main
{
    // 外部触发Task的取消操作随时可能发生，因此通过markOperationCancel属性来标记触发事务，operation检查markOperationCancel来实时判断和执行cancel操作，保证线程和时序安全
    if (self.task.markOperationCancel)
    {
        return;
    }
        
    if (self.task.status == TaskPrepared)
    {
        [self.task start];
    }
    
    if (!self.task.markOperationCancel && self.task.status == TaskRunning)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow] target:self selector:@selector(cancel) userInfo:nil repeats:NO];
        
        while (!self.task.markOperationCancel && self.task.status == TaskRunning)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        [timer invalidate];
    }
    
    // Task结束时要求内部执行cancel操作，为避免重复执行cancel操作，这里检查Task状态
    if (self.task.status == TaskRunning)
    {
        [self.task cancel];
    }
}

@end
