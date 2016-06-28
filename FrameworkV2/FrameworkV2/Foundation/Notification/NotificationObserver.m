//
//  NotificationObserver.m
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "NotificationObserver.h"

@implementation NotificationObserver

@end


@interface NotificationObservingSet ()
{
    NSMutableArray *_observerArray;
    
    NSMutableDictionary *_observerDictionary;
}

@end


@implementation NotificationObservingSet

@synthesize observerArray = _observerArray;

@synthesize observerDictionary = _observerDictionary;

- (id)init
{
    if (self = [super init])
    {
        _observerArray = [[NSMutableArray  alloc] init];
        
        _observerDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)notifyObservers:(void (^)(id))notification onThread:(NSThread *)thread
{
    if (notification)
    {
        for (NotificationObserver *observer in self.observerArray)
        {
            [observer operate:^{
                
                notification(observer.observer);
                
            } onThread:observer.notifyThread ? observer.notifyThread : [NSThread currentThread]];
        }
        
        for (NotificationObserver *observer in [self.observerDictionary allValues])
        {
            [observer operate:^{
                
                notification(observer.observer);
                
            } onThread:observer.notifyThread ? observer.notifyThread : [NSThread currentThread]];
        }
    }
}

@end
