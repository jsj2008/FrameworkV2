//
//  SharedHTTPSessionManager.h
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPSession.h"

/*********************************************************
 
    @class
        SharedHTTPSessionManager
 
    @abstract
        HTTP会话单例管理器
 
    @discussion
        1，当默认会话发生系统错误时，管理器内部会重建会话以保证一直有会话可使用
 
 *********************************************************/

@interface SharedHTTPSessionManager : NSObject <URLSessionDelegate>

/*!
 * @brief 单例
 */
+ (SharedHTTPSessionManager *)sharedInstance;

/*!
 * @brief 默认配置的会话
 * @discussion 使用系统默认的URLCache，CookiStorage，CredentialStorage
 */
@property (atomic) HTTPSession *defaultConfigurationSession;

/*!
 * @brief 瞬时配置的会话
 */
@property (atomic) HTTPSession *ephemeralConfigurationSession;

@end
