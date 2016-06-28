//
//  AsyncTaskDispatcher.m
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "AsyncTaskDispatcher.h"
#import "TaskOperation.h"
#import "Task+Operation.h"

NSInteger const AsyncTaskDispatcherMaxConcurrentTaskCount = NSOperationQueueDefaultMaxConcurrentOperationCount;


@interface AsyncTaskDispatcher ()

@property (nonatomic) NSMutableArray<Task *> *queuedTasks;

@property (nonatomic) NSOperationQueue *queue;

@end


@implementation AsyncTaskDispatcher

- (instancetype)init
{
    if (self = [super init])
    {
        self.queuedTasks = [[NSMutableArray alloc] init];
        
        self.queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)setMaxConcurrentTaskCount:(NSInteger)maxConcurrentTaskCount
{
    self.queue.maxConcurrentOperationCount = maxConcurrentTaskCount;
}

- (NSArray<Task *> *)tasks
{
    return self.queuedTasks;
}

- (void)addTask:(Task *)task
{
    if (!task)
    {
        return;
    }
    
    [self.queuedTasks addObject:task];
    
    if (!task.notifyThread)
    {
        task.notifyThread = [NSThread currentThread];
    }
    
    TaskOperation *operation = [[TaskOperation alloc] initWithTask:task];
    
    [self.queue addOperation:operation];
}

- (void)removeTask:(Task *)task
{
    if (!task)
    {
        return;
    }
    
    [self.queuedTasks removeObject:task];
}

- (void)cancelTask:(Task *)task
{
    if (!task)
    {
        return;
    }
    
    // 通过markOperationCancel属性在operation内部管理Task的状态
    if ([self.queuedTasks containsObject:task])
    {
        task.delegate = nil;
        
        task.markOperationCancel = YES;
        
        if (task.runningThread && task.runningThread.isExecuting)
        {
            [task performSelector:@selector(triggerOperationThread) onThread:task.runningThread withObject:nil waitUntilDone:NO];
        }
        
        [self.queuedTasks removeObject:task];
    }
}

- (void)cancel
{
    // 通过markOperationCancel属性在operation内部管理Task的状态
    for (Task *task in self.queuedTasks)
    {
        task.delegate = nil;
        
        task.markOperationCancel = YES;
        
        if (task.runningThread && task.runningThread.isExecuting)
        {
            [task performSelector:@selector(triggerOperationThread) onThread:task.runningThread withObject:nil waitUntilDone:NO];
        }
    }
    
    [self.queuedTasks removeAllObjects];
}

@end
