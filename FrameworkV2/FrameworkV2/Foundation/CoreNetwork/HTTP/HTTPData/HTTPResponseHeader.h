//
//  HTTPResponseHeader.h
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @class
        HTTPResponseHeader
 
    @abstract
        HTTP响应头
 
 ******************************************************/

@interface HTTPResponseHeader : NSObject <NSCopying>

/*!
 * @brief HTTP版本
 */
@property (nonatomic, copy) NSString *version;

/*!
 * @brief 状态码
 */
@property (nonatomic) NSInteger statusCode;

/*!
 * @brief 状态描述
 */
@property (nonatomic, copy) NSString *statusDescription;

/*!
 * @brief 响应首部
 */
@property (nonatomic) NSDictionary *headerFields;

@end
