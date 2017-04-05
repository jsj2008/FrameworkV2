//
//  LightLoadingPermanentQueue.m
//  FoundationProject
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "LightLoadingPermanentQueue.h"

@interface LightLoadingPermanentQueue ()

@property (nonatomic) NSMutableArray *blocks;

@property (nonatomic) dispatch_queue_t syncQueue;

@property (nonatomic) BOOL isCancelled;

@property (nonatomic) NSThread *runningThread;

- (void)operate;

@end


@implementation LightLoadingPermanentQueue

- (void)dealloc
{
    dispatch_sync(self.syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        self.blocks = [[NSMutableArray alloc] init];
        
        self.syncQueue = dispatch_queue_create("LightLoadingPermanentQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)start
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow] target:self selector:@selector(stop) userInfo:nil repeats:NO];
        
        self.runningThread = [NSThread currentThread];
        
        while (!self.isCancelled)
        {
            NSMutableArray *blocks = [[NSMutableArray alloc] init];
            
            dispatch_sync(self.syncQueue, ^{
                
                [blocks addObjectsFromArray:self.blocks];
                
                [self.blocks removeAllObjects];
            });
            
            for (void (^block)(void) in blocks)
            {
                block();
            }
            
            [blocks removeAllObjects];
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    });
}

- (void)stop
{
    self.isCancelled = YES;
    
    if ([self.runningThread isExecuting])
    {
        [self performSelector:@selector(operate) onThread:self.runningThread withObject:nil waitUntilDone:NO];
    }
}

- (void)addBlock:(void (^)())block
{
    if (block)
    {
        dispatch_sync(self.syncQueue, ^{
            
            [self.blocks addObject:block];
        });
        
        if ([self.runningThread isExecuting])
        {
            [self performSelector:@selector(operate) onThread:self.runningThread withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)operate
{
    
}

@end
