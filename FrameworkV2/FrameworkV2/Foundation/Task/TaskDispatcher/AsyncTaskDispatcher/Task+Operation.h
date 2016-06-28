//
//  Task+Operation.h
//  Test
//
//  Created by ww on 16/6/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "Task.h"

/**********************************************************
 
    @category
        Task (Operation)
 
    @abstract
        Task的Operation扩展
 
 **********************************************************/

@interface Task (Operation)

/*!
 * @brief Task取消标记
 */
@property (nonatomic) BOOL markOperationCancel;

/*!
 * @brief 触发operation所在线程
 * @discussion 空方法，仅仅为触发线程提供的方法
 */
- (void)triggerOperationThread;

@end
