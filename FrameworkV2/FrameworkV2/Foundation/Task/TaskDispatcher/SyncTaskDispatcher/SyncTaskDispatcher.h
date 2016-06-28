//
//  SyncTaskDispatcher.h
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "TaskDispatcher.h"

/**********************************************************
 
    @class
        SyncTaskDispatcher
 
    @abstract
        Task同步调度器，负责Task的派发和调度，同步执行Task
 
    @discussion
        1，SyncTaskDispatcher添加任务时，会立即启动Task
        2，添加Task时，若未指定其通知线程，默认将当前线程设置成通知线程
 
 **********************************************************/

@interface SyncTaskDispatcher : TaskDispatcher

@end
