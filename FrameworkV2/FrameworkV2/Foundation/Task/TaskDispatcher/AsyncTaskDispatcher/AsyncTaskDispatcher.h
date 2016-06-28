//
//  AsyncTaskDispatcher.h
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "TaskDispatcher.h"

/**********************************************************
 
    @class
        AsyncTaskDispatcher
 
    @abstract
        Task异步调度器，负责Task的派发和调度，异步执行Task
 
    @discussion
        1，AsyncTaskDispatcher添加任务时，会在新线程中启动Task操作
        2，AsyncTaskDispatcher允许配置Task的并发量
        3，添加Task时，若未指定其通知线程，将默认将当前线程设置成通知线程
 
 **********************************************************/

@interface AsyncTaskDispatcher : TaskDispatcher

/*!
 * @brief Task并发量
 * @discussion 默认AsyncTaskDispatcherMaxConcurrentTaskCount，并发量无限
 */
@property (nonatomic) NSInteger maxConcurrentTaskCount;

@end


// AsyncTaskDispatcher的最大Task并发量
extern NSInteger const AsyncTaskDispatcherMaxConcurrentTaskCount;
