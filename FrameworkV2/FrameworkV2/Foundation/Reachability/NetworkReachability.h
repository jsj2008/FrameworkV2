//
//  NetworkReachability.h
//  FoundationProject
//
//  Created by user on 13-12-12.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

/*********************************************************
 
    @enum
        NetworkReachStatus
 
    @abstract
        网络连接状态
 
 *********************************************************/

typedef NS_ENUM(NSInteger, NetworkReachStatus)
{
    NetworkReachStatus_NotReachable = 0,  // 不可达
    NetworkReachStatus_ViaWiFi      = 1,  // WiFi连接
    NetworkReachStatus_ViaWWAN      = 2   // 蜂窝网络连接
};


/*!
 * @brief 网络连接状态变化后的通知块，可在这里执行针对网络变化的代码
 * @param status 新的网络状态
 */
typedef void (^NetworkReachabilityChangedNotificationBlock)(NetworkReachStatus fromStatus, NetworkReachStatus toStatus);


/*********************************************************
 
    @class
        NetworkReachability
 
    @abstract
        网络连接状态检查器，负责获取网络状态和状态变化的通知
 
 *********************************************************/

@interface NetworkReachability : NSObject

/*!
 * @brief 初始化
 * @param reachabilityRef SCNetworkReachabilityRef对象
 * @result 初始化后的对象
 */
- (instancetype)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef;

/*!
 * @brief 连接的实时状态
 */
@property (nonatomic) NetworkReachStatus status;

/*!
 * @brief 连接变化的通知块
 */
@property (nonatomic, copy) NetworkReachabilityChangedNotificationBlock notificationBlock;

/*!
 * @brief 启动消息通知
 * @result 是否正确启动
 */
- (BOOL)startNotifier;

/*!
 * @brief 关闭消息通知
 */
- (void)stopNotifier;

@end


/*********************************************************
 
    @class
        NetworkReachability (ReachabilityType)
 
    @abstract
        NetworkReachability的可达类型扩展
 
 *********************************************************/

@interface NetworkReachability (ReachabilityType)

/*!
 * @brief 连接到指定地址的网络连接状态检查器
 * @param hostAddress 连接的目标地址
 * @result 网络连接状态检查器
 */
+ (NetworkReachability *)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * @brief 连接到指定主机的网络连接状态检查器
 * @param hostName 连接的目标主机名字
 * @result 网络连接状态检查器
 */
+ (NetworkReachability *)reachabilityWithHostName:(NSString *)hostName;

/*!
 * @brief 设备的网络连接状态检查器
 * @result 网络连接状态检查器
 */
+ (NetworkReachability *)reachabilityForInternetConnection;

@end
