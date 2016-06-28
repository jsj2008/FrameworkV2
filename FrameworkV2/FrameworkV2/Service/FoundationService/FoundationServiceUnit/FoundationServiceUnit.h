//
//  FoundationServiceUnit.h
//  FoundationProject
//
//  Created by user on 13-11-24.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        FoundationServiceUnit
 
    @abstract
        基础应用服务单元，负责启动和关闭应用框架，基本引擎等系统服务
 
    @discussion
        1，应当在主线程启动和关闭应用服务
        2，应当在应用启动后尽快启动应用服务，在应用结束前关闭应用服务
 
 *********************************************************/

@interface FoundationServiceUnit : NSObject

/*!
 * @brief 单例
 */
+ (FoundationServiceUnit *)sharedInstance;

/*!
 * @brief 启动应用服务
 */
- (void)start;

/*!
 * @brief 关闭应用服务
 */
- (void)stop;

@end
