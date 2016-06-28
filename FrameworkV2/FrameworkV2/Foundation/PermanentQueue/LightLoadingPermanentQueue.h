//
//  LightLoadingPermanentQueue.h
//  FoundationProject
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        LightLoadingPermanentTaskQueue
 
    @abstract
        轻载常驻任务队列，内建常驻线程，运行轻载任务
 
    @discussion
        1，本队列可以用于执行信号监听等任务，也可以用于借助内建线程发送消息，队列内不能执行可能长时间堵塞线程的操作
        2，本队列的设计初衷是提供一个常驻线程，用来承载操作时间较短的跨线程操作，例如消息通知，信号通知等
 
 *********************************************************/

@interface LightLoadingPermanentQueue : NSObject

/*!
 * @brief 起动内建线程和内部管理模块
 */
- (void)start;

/*!
 * @brief 停止内建线程，撤销管理模块
 */
- (void)stop;

/*!
 * @brief 添加任务块到内建线程执行
 * @param block 任务块承载对象
 * @result 队列正常运行时返回YES，反之返回NO
 */
- (void)addBlock:(void (^)())block;

@end
