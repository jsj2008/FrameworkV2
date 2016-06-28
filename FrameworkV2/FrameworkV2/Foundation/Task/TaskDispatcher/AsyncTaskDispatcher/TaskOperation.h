//
//  TaskOperation.h
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

/**********************************************************
 
    @class
        TaskOperation
 
    @abstract
        管理Task操作的Operation
 
 **********************************************************/

@interface TaskOperation : NSOperation

/*!
 * @brief 初始化
 * @param task Task对象
 * @result 初始化后的对象
 */
- (instancetype)initWithTask:(Task *)task;

/*!
 * @brief task
 */
@property (nonatomic, readonly) Task *task;

@end
