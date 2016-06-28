//
//  HTTPRequestHeader.h
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @class
        HTTPRequestHeader
 
    @abstract
        HTTP请求头
 
 ******************************************************/

@interface HTTPRequestHeader : NSObject <NSCopying>

/*!
 * @brief HTTP版本
 */
@property (nonatomic, copy) NSString *version;

/*!
 * @brief URL
 */
@property (nonatomic, copy) NSURL *URL;

/*!
 * @brief 请求方法
 */
@property (nonatomic, copy) NSString *method;

/*!
 * @brief 请求首部
 */
@property (nonatomic) NSDictionary *headerFields;

@end
