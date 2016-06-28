//
//  TaskDispatcher.h
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

/**********************************************************
 
    @class
        TaskDispatcher
 
    @abstract
        Task调度器，负责Task的派发和调度
 
    @discussion
        1，TaskDispatcher是抽象类，由子类实现具体功能
        2，TaskDispatcher不保证线程安全
 
 **********************************************************/

@interface TaskDispatcher : NSObject

/*!
 * @brief 当前所有任务
 */
@property (nonatomic, readonly) NSArray<Task *> *tasks;

/*!
 * @brief 添加并执行任务
 * @discussion 子类需重写本方法
 * @param task 待执行的任务
 */
- (void)addTask:(Task *)task;

/*!
 * @brief 移除任务
 * @discussion 移除任务仅仅将任务从队列中移除，并不会干扰其工作流程；但由于移除后已经脱离调度，后续调度器将无法正常对其调度
 * @discussion 子类需重写本方法
 * @param task 待移除的任务
 */
- (void)removeTask:(Task *)task;

/*!
 * @brief 从队列中取消并移除任务
 * @discussion 取消操作将尽快使Task执行其cancel操作
 * @discussion 子类需重写本方法
 * @param task 待取消的任务
 */
- (void)cancelTask:(Task *)task;

/*!
 * @brief 取消并移除所有队列中的任务
 */
- (void)cancel;

@end
