//
//  StorageUnit.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StorageUnitDelegate;


/*********************************************************
 
    @class
        StorageUnit
 
    @abstract
        存储服务单元，负责启动和关闭存储服务
 
    @discussion
        1，应当在主线程启动和关闭存储服务
        2，应当在应用启动后尽快启动存储服务，在应用结束前关闭存储服务
 
 *********************************************************/

@interface StorageUnit : NSObject

/*!
 * @brief 单例
 */
+ (StorageUnit *)sharedInstance;

/*!
 * @brief 启动存储服务
 */
- (void)start;

/*!
 * @brief 关闭存储服务
 */
- (void)stop;

@end
