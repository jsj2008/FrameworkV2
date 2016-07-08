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

- (NSLock *)delegateLock;

@end


#pragma mark - NSObject (Delegate)


@implementation NSObject (Delegate)

- (void)addDelegate:(id)delegate
{
    if (!delegate)
    {
        return;
    }
    
    NSLock *lock = [self delegateLock];
    
    NSString *index = [NSString stringWithFormat:@"%llx", (long long)delegate];
    
    NSThread *currentThread = [NSThread currentThread];
    
    [lock lock];
    
    NotificationObservingSet *set = [self delegateNotificationObservingSet];
    
    if (![[set.observerDictionary allKeys] containsObject:index])
    {
        NotificationObserver *observer = [[NotificationObserver alloc] init];
        
        observer.observer = delegate;
        
        observer.notifyThread = currentThread;
        
        [set.observerDictionary setObject:observer forKey:index];
    }
    
    [lock unlock];
}

- (void)removeDelegate:(id)delegate
{
    if (!delegate)
    {
        return;
    }
    
    NSLock *lock = [self delegateLock];
    
    NSString *index = [NSString stringWithFormat:@"%llx", (long long)delegate];
    
    [lock lock];
    
    NotificationObservingSet *set = [self delegateNotificationObservingSet];
    
    [set.observerDictionary removeObjectForKey:index];
    
    [lock unlock];
}

- (void)operateDelegate:(void (^)(id))operation
{
    if (operation)
    {
        NSLock *lock = [self delegateLock];
        
        [lock lock];
        
        [[self delegateNotificationObservingSet] notifyObservers:operation onThread:nil];
        
        [lock unlock];
    }
}

@end


#pragma mark - NSObject (Delegate_Internal)


static char kNSObjectPropertyKey_DelegateNotificationObservingSet[] = "delegateNotificationObservingSet";

static char kNSObjectPropertyKey_DelegateLock[] = "delegateLock";


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

- (NSLock *)delegateLock
{
    NSLock *lock = objc_getAssociatedObject(self, kNSObjectPropertyKey_DelegateLock);
    
    if (!lock)
    {
        lock = [[NSLock alloc] init];
        
        objc_setAssociatedObject(self, kNSObjectPropertyKey_DelegateLock, lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return lock;
}

@end
