//
//  TCPServerIPAddress.h
//  HS
//
//  Created by ww on 16/6/2.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @class
        TCPServerIPAddress
 
    @abstract
        TCP服务器IP地址
 
 ******************************************************/

@interface TCPServerIPAddress : NSObject

/*!
 * @brief 名称
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief IPv4地址
 */
@property (nonatomic, copy) NSString *IPv4Address;

/*!
 * @brief IPv6地址
 */
@property (nonatomic, copy) NSString *IPv6Address;

@end


/******************************************************
 
    @category
        TCPServerIPAddress (System)
 
    @abstract
        TCP服务器IP地址的系统扩展
 
 ******************************************************/

@interface TCPServerIPAddress (System)

/*!
 * @brief 获取系统IP地址
 * @result 系统IP地址
 */
+ (NSDictionary<NSString *, TCPServerIPAddress *> *)systemIPAddresses;

@end
