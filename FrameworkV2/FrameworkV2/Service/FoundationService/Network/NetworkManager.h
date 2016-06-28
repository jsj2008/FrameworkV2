//
//  NetworkManager.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkReachability.h"

@protocol NetworkManagerDelegate;


/*********************************************************
 
    @class
        NetworkManager
 
    @abstract
        网络管理器，用于管理网络状态变化等
 
 *********************************************************/

@interface NetworkManager : NSObject

/*!
 * @brief 单例
 */
+ (NetworkManager *)sharedInstance;

/*!
 * @brief 当前网络状态
 */
@property (nonatomic, readonly) NetworkReachStatus currentNetworkReachStatus;

/*!
 * @brief 添加代理
 * @param delegate 代理对象
 */
- (void)addDelegate:(id<NetworkManagerDelegate>)delegate;

/*!
 * @brief 移除代理
 * @param delegate 代理对象
 */
- (void)removeDelegate:(id<NetworkManagerDelegate>)delegate;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 关闭
 */
- (void)stop;

@end


/*********************************************************
 
    @protocol
        NetworkManagerDelegate
 
    @abstract
        网络管理器代理通知协议
 
 *********************************************************/

@protocol NetworkManagerDelegate <NSObject>

/*!
 * @brief 监听到网络状态变化
 * @param manager 管理器对象
 * @param fromStatus 原网络状态
 * @param toStatus 现网络状态
 */
- (void)networkManager:(NetworkManager *)manager didChangeFromStatus:(NetworkReachStatus)fromStatus toStatus:(NetworkReachStatus)toStatus;

@end
