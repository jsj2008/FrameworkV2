//
//  NSObject+HTTPServerNotification.h
//  HS
//
//  Created by ww on 16/5/24.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @category
        NSObject (HTTPServerNotification)
 
    @abstract
        NSObject的HTTP服务器通知扩展
 
 ******************************************************/

@interface NSObject (HTTPServerNotification)

/*!
 * @brief 跨线程通知
 * @param notification 通知块
 * @param thread 通知线程
 */
- (void)HTTPServerNotify:(void (^)(void))notification onThread:(NSThread *)thread;

/*!
 * @brief 通知操作
 * @param notification 通知块
 */
- (void)HTTPServerNotify:(void (^)(void))notification;

@end
