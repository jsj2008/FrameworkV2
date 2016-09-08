//
//  LoginManager.h
//  FrameworkV2
//
//  Created by ww on 16/8/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginManagerDelegate;


@interface LoginManager : NSObject

/*!
 * @brief 单例
 */
+ (LoginManager *)sharedInstance;

/*!
 * @brief 添加delegate
 * @discussion 添加delegate的同时，将设置当前线程为delegate消息通知线程
 * @param delegate delegate对象
 */
- (void)addDelegate:(id<LoginManagerDelegate>)delegate;

/*!
 * @brief 移除delegate
 * @param delegate delegate对象
 */
- (void)removeDelegate:(id<LoginManagerDelegate>)delegate;

@property (nonatomic, readonly) id currentLoginedUser;

- (void)loginWithUser:(id)user;

- (void)logout;

@end


@protocol LoginManagerDelegate <NSObject>

- (void)loginManagerDidLogin:(LoginManager *)manager;

- (void)loginManagerDidLogout:(LoginManager *)manager;

@end
