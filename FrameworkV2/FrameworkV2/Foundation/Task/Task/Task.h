//
//  Task.h
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @enum
        TaskStatus
 
    @abstract
        Task运行状态标志
 
 **********************************************************/

typedef NS_ENUM(NSUInteger, TaskStatus)
{
    TaskPrepared  = 0, // 准备状态，Task初始化后的状态
    TaskRunning   = 1, // 运行状态，Task启动后的状态
    TaskFinished  = 2  // 结束状态，Task取消后的状态
};

/**********************************************************
 
    @class
        Task
 
    @abstract
        完成特定功能的任务的对象
 
    @discussion
        1，Task内部不执行任何实际操作，仅仅处理状态和时序，配置一些属性，具体的功能需要子类重写main方法实现
        2，Task通过delegate来实现消息的传递
 
 **********************************************************/

@interface Task : NSObject

/*!
 * @brief 运行状态
 */
@property (nonatomic, readonly) TaskStatus status;

/*!
 * @brief 协议消息的代理
 */
@property (nonatomic, weak) id delegate;

/*!
 * @brief 运行线程，指向执行start方法的线程
 */
@property (nonatomic, readonly) NSThread *runningThread;

/*!
 * @brief 接收通知的线程
 */
@property (nonatomic) NSThread *notifyThread;

/*!
 * @brief 启动任务，配置Task并调用main方法，调整运行状态为运行状态
 * @discussion 本方法在调用main方法前会做一些准备工作，是真正启动任务的方法。对于子类，不允许重写本方法
 */
- (void)start;

/*!
 * @brief 任务实现，在这里实现Task要实现的功能
 * @discussion 需要子类重新实现该方法以实现不同的任务功能
 */
- (void)main;

/*!
 * @brief 取消任务
 * @discussion 执行清理内部变量并调整运行状态为结束。在Task结束前必须执行本方法以彻底释放资源并调整运行状态
 * @discussion 子类若重写cancel方法需先调用父类cancel方法
 */
- (void)cancel;

@end


/**********************************************************
 
    @category
        Task (Notification)
 
    @abstract
        Task的消息通知扩展
 
 **********************************************************/

@interface Task (Notification)

/*!
 * @brief 消息通知
 * @discussion 通知在指定线程发送
 * @param notification 消息块
 * @param thread 消息发送线程，将消息块放入指定线程的下一个runloop中执行，若为nil，使用当前线程
 */
- (void)notify:(void (^)(void))notification onThread:(NSThread *)thread;

@end
