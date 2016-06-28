//
//  NSObject+Delegate.m
//  MarryYou
//
//  Created by ww on 15/7/22.
//  Copyright (c) 2015年 MiaoTo. All rights reserved.
//

#import "NSObject+Delegate.h"
#import <objc/runtime.h>
#import "NotificationObserver.h"

#pragma mark - NSObject (Delegate_Internal)

/**********************************************************
 
    @category
        NSObject (Delegate_Internal)
 
    @abstract
        NSObject的Delegate内部扩展
 
 **********************************************************/

@interface NSObject (Delegate_Internal)

- (NotificationObservingSet *)delegateNotificationObservingSet;

- (dispatch_queue_t)delegateSyncQueue;

@end


#pragma mark - NSObject (Delegate)


@implementation NSObject (Delegate)

- (void)addDelegate:(id)delegate
{
    if (delegate)
    {
        dispatch_queue_t syncQueue = [self delegateSyncQueue];
        
        NSString *index = [NSString stringWithFormat:@"%llx", (long long)delegate];
        
        NSThread *currentThread = [NSThread currentThread];
        
        dispatch_sync(syncQueue, ^{
            
            NotificationObservingSet *set = [self delegateNotificationObservingSet];
            
            if (![[set.observerDictionary allKeys] containsObject:index])
            {
                NotificationObserver *observer = [[NotificationObserver alloc] init];
                
                observer.observer = delegate;
                
                observer.notifyThread = currentThread;
                
                [set.observerDictionary setObject:observer forKey:index];
            }
        });
    }
}

- (void)removeDelegate:(id)delegate
{
    if (delegate)
    {
        dispatch_queue_t syncQueue = [self delegateSyncQueue];
        
        NSString *index = [NSString stringWithFormat:@"%llx", (long long)delegate];
        
        dispatch_sync(syncQueue, ^{
            
            NotificationObservingSet *set = [self delegateNotificationObservingSet];
            
            [set.observerDictionary removeObjectForKey:index];
        });
    }
}

- (void)operateDelegate:(void (^)(id))operation
{
    if (operation)
    {
        dispatch_queue_t syncQueue = [self delegateSyncQueue];
        
        dispatch_sync(syncQueue, ^{
            
            [[self delegateNotificationObservingSet] notifyObservers:operation onThread:nil];
        });
    }
}

@end


#pragma mark - NSObject (Delegate_Internal)


static char kNSObjectPropertyKey_DelegateNotificationObservingSet[] = "delegateNotificationObservingSet";

static char kNSObjectPropertyKey_DelegateSyncQueue[] = "delegateSyncQueue";


@implementation NSObject (Delegate_Internal)

- (NotificationObservingSet *)delegateNotificationObservingSet
{
    NotificationObservingSet *set = objc_getAssociatedObject(self, kNSObjectPropertyKey_DelegateNotificationObservingSet);
    
    if (!set)
    {
        set = [[NotificationObservingSet alloc] init];
        
        objc_setAssociatedObject(self, kNSObjectPropertyKey_DelegateNotificationObservingSet, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return set;
}

- (dispatch_queue_t)delegateSyncQueue
{
    dispatch_queue_t queue = objc_getAssociatedObject(self, kNSObjectPropertyKey_DelegateSyncQueue);
    
    if (!queue)
    {
        queue = dispatch_queue_create("NSObject_delegateSyncQueue", NULL);
        
        objc_setAssociatedObject(self, kNSObjectPropertyKey_DelegateSyncQueue, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return queue;
}

@end
