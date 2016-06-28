//
//  HTTPRequestTask.h
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "Task.h"

@class HTTPRequestInternetPassword;


/*********************************************************
 
    @class
        HTTPRequestTask
 
    @abstract
        HTTP请求Task
 
    @discussion
        HTTPRequestTask是纯抽象类，必须由子类来完成具体功能
 
 *********************************************************/

@interface HTTPRequestTask : Task

/*!
 * @brief 初始化
 * @param URL 请求URL
 * @result 初始化对象
 */
- (instancetype)initWithURL:(NSURL *)URL;

/*!
 * @brief 请求URL
 */
@property (nonatomic, copy, readonly) NSURL *URL;

/*!
 * @brief 超时时间
 */
@property (nonatomic) NSTimeInterval timeout;

/*!
 * @brief 请求首部
 */
@property (nonatomic) NSDictionary<NSString *, NSString *> *headerFields;

/*!
 * @brief 认证密码
 */
@property (nonatomic) HTTPRequestInternetPassword *internetPassword;

@end


/*********************************************************
 
    @class
        HTTPRequestInternetPassword
 
    @abstract
        HTTP请求认证密码
 
 *********************************************************/

@interface HTTPRequestInternetPassword : NSObject

/*!
 * @brief 初始化
 * @param user 认证用户
 * @param password 密码
 * @result 初始化对象
 */
- (instancetype)initWithUser:(NSString *)user password:(NSString *)password;

/*!
 * @brief 认证用户
 */
@property (nonatomic, copy) NSString *user;

/*!
 * @brief 密码
 */
@property (nonatomic, copy) NSString *password;

@end
