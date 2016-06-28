//
//  HTTPRequestResponseContent.h
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        HTTPRequestResponseContent
 
    @abstract
        HTTP请求的响应内容
 
    @discussion
        HTTPRequestResponseContent是一个纯抽象类
 
 *********************************************************/

@interface HTTPRequestResponseContent : NSObject

/*!
 * @brief 初始化
 * @param error 请求返回的错误信息
 * @param response 响应头
 * @param data 响应数据
 * @result 初始化对象
 */
- (instancetype)initWithRequestError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

/*!
 * @brief 请求返回的错误信息
 */
@property (nonatomic, readonly) NSError *requestError;

/*!
 * @brief 响应头
 */
@property (nonatomic, readonly) NSHTTPURLResponse *response;

/*!
 * @brief 响应数据
 */
@property (nonatomic, readonly) NSData *data;

@end
