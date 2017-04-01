//
//  NSHTTPURLResponse+ContentValidation.h
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPResponseValidationCondition;


/*********************************************************
 
    @class
        NSHTTPURLResponse (ContentValidation)
 
    @abstract
        HTTP响应的有效性验证
 
 *********************************************************/

@interface NSHTTPURLResponse (ContentValidation)

/*!
 * @brief 响应内容是否有效
 * @discussion 通过condition检查响应内容是否有效，若无效，将在error参数中提供相关信息
 * @param error 错误信息，userInfo中额外提供NSURLErrorFailingURLErrorKey信息
 * @result 响应内容是否有效
 */
- (BOOL)isContentValidInCondition:(HTTPResponseValidationCondition *)condition error:(NSError **)error;

@end


/*********************************************************
 
    @class
        HTTPResponseValidationCondition
 
    @abstract
        HTTP响应有效性条件
 
    @discussion
        各项有效性条件允许为空，为空将跳过该项检查
 
 *********************************************************/

@interface HTTPResponseValidationCondition : NSObject

/*!
 * @brief 可接受的状态码
 */
@property (nonatomic) NSArray<NSNumber *> *acceptableStatusCodes;

/*!
 * @brief 可接受的资源类型（Content-Type首部指定）
 */
@property (nonatomic) NSArray<NSString *> *acceptableMIMETypes;

/*!
 * @brief 可接受的字符编码类型（Content-Type首部指定）
 * @discussion 编码类型由CFStringEncoding对象组成
 */
@property (nonatomic) NSArray<NSNumber *> *acceptableStringEncodings;

@end


/*!
 * @brief HTTP响应内容有效性检查的错误域名
 */
extern NSString * const HTTPResponseContentValidationErrorDomain;

typedef NS_ENUM(NSUInteger, HTTPResponseContentValidationErrorCode)
{
    HTTPResponseContentValidationErrorUnacceptableStatusCode = 1,
    HTTPResponseContentValidationErrorUnacceptableMIMEType = 2,
    HTTPResponseContentValidationErrorUnacceptableStringEncoding = 3
};
