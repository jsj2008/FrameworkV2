//
//  NSObject+ThreadOperation.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/**********************************************************
 
    @category
        NSObject (ThreadOperation)
 
    @abstract
        NSObject的通知扩展，用于发送block通知
 
 **********************************************************/

@interface NSObject (ThreadOperation)

/*!
 * @brief 跨线程block操作
 * @param operation 操作块
 * @param thread 通知线程
 */
- (void)operate:(void (^)(void))operation onThread:(NSThread *)thread;

/*!
 * @brief block操作
 * @param operation 操作块
 */
- (void)operate:(void (^)(void))operation;

@end
