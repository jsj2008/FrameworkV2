//
//  SyncTaskDispatcher.m
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "SyncTaskDispatcher.h"

@interface SyncTaskDispatcher ()

@property (nonatomic) NSMutableArray<Task *> *queuedTasks;

@end


@implementation SyncTaskDispatcher

- (instancetype)init
{
    if (self = [super init])
    {
        self.queuedTasks = [[NSMutableArray alloc] init];
    }
    
    return self;
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
    
    [task start];
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
    
    if ([self.queuedTasks containsObject:task])
    {
        task.delegate = nil;
        
        [task cancel];
        
        [self.queuedTasks removeObject:task];
    }
}

- (void)cancel
{
    for (Task *task in self.queuedTasks)
    {
        task.delegate = nil;
        
        [task cancel];
    }
    
    [self.queuedTasks removeAllObjects];
}

@end
