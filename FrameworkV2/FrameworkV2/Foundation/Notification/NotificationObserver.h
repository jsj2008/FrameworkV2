//
//  NotificationObserver.h
//  FoundationProject
//
//  Created by user on 13-11-19.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ThreadOperation.h"

/*********************************************************
 
    @class
        NotificationObserver
 
    @abstract
        消息观察者，用于承载异步任务的消息观察者信息
 
 *********************************************************/

@interface NotificationObserver : NSObject

/*!
 * @brief 实际观察者
 */
@property (nonatomic, weak) id observer;

/*!
 * @brief 接收消息的线程
 */
@property (nonatomic, retain) NSThread *notifyThread;

@end


/*********************************************************
 
    @class
        NotificationObservingSet
 
    @abstract
        观察者集合，用于承载对单个对象的多个观察者信息
 
 *********************************************************/

@interface NotificationObservingSet : NSObject

/*!
 * @brief 被观察对象
 */
@property (nonatomic) id object;

/*!
 * @brief 观察者数组
 * @discussion 在NotificationObservingSet初始化时，将自动创建本数组
 */
@property (nonatomic, readonly) NSMutableArray<NotificationObserver *> *observerArray;

/*!
 * @brief 观察者字典
 * @discussion 在NotificationObservingSet初始化时，将自动创建本字典
 */
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NotificationObserver *> *observerDictionary;

/*!
 * @brief 在指定线程上发送块消息
 * @discussion 消息块将在之后的runloop中得到执行
 * @param notification 待发送的消息
 * @param thread 发送线程，若为nil，则在各NotificationObserver的通知线程上发送消息，若NotificationObserver的通知线程为nil，则在当前线程上发送消息
 */
- (void)notifyObservers:(void (^)(id observer))notification onThread:(NSThread *)thread;

@end
