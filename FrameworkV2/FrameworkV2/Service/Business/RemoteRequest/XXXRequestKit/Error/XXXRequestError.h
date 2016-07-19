//
//  XXXRequestError.h
//  FrameworkV2
//
//  Created by ww on 16/7/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

// XXX请求错误域
extern NSString * const XXXRequestErrorDomain;


/******************************************************
 
    @enum
        XXXRequestErrorCode
 
    @abstract
        XXX请求错误码
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, XXXRequestErrorCode)
{
    XXXRequestErrorInvalidDataNode = 1
};


/******************************************************
 
    @category
        NSError (XXXRequest)
 
    @abstract
        错误对象的XXX请求扩展
 
 ******************************************************/

@interface NSError (XXXRequest)

/*!
 * @brief XXX请求错误对象
 * @param code 错误码
 * @param description 错误描述
 * @result XXX请求错误对象
 */
+ (NSError *)XXXRequestErrorWithCode:(XXXRequestErrorCode)code description:(NSString *)description;

/*!
 * @brief XXX请求错误对象
 * @param code 错误码
 * @result XXX请求错误对象
 */
+ (NSError *)XXXRequestErrorWithCode:(XXXRequestErrorCode)code;

@end
