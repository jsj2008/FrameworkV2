//
//  DispatchableTask.h
//  Test
//
//  Created by ww on 16/6/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "Task.h"
#import "SyncTaskDispatcher.h"
#import "AsyncTaskDispatcher.h"

/*********************************************************
 
    @class
        DispatchableTask
 
    @abstract
        可调度内部Task的Task，集成了内部的Task调度器
 
    @discussion
        1，DispatchableTask在初始化时生成了一个同步和一个异步的Task调度器，子类可直接使用
        2，DispatchableTask的cancel操作会自动调用两个调度器的cancel操作并释放调度器
 
 *********************************************************/

@interface DispatchableTask : Task

/*!
 * @brief 同步Task调度器
 */
@property (nonatomic, readonly) SyncTaskDispatcher *syncTaskDispatcher;

/*!
 * @brief 异步Task调度器
 * @discussion 默认无限并发量
 */
@property (nonatomic, readonly) AsyncTaskDispatcher *asyncTaskDispatcher;

@end
