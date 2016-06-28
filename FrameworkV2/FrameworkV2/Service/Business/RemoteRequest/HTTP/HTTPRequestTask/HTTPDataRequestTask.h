//
//  HTTPDataRequestTask.h
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestTask.h"

/*********************************************************
 
    @class
        HTTPDataRequestTask
 
    @abstract
        HTTP数据请求Task
 
 *********************************************************/

@interface HTTPDataRequestTask : HTTPRequestTask

/*!
 * @brief 请求的缓存使用策略，控制发出请求时是否使用本地缓存
 * @discussion 默认NSURLRequestReloadIgnoringCacheData
 */
@property (nonatomic) NSURLRequestCachePolicy cachePolicy;

/*!
 * @brief 是否允许保存缓存，控制当请求的响应数据可缓存时是否允许缓存
 * @discussion 默认YES
 */
@property (nonatomic) BOOL cacheStorable;

@end


/*********************************************************
 
    @protocol
        HTTPDataRequestTaskDelegate
 
    @abstract
        HTTP数据请求Task的代理协议
 
 *********************************************************/

@protocol HTTPDataRequestTaskDelegate <NSObject>

/*!
 * @brief 请求结束
 * @param task 请求Task
 * @param error 错误信息
 * @param response 响应信息
 * @param data 响应数据
 */
- (void)HTTPDataRequestTask:(HTTPDataRequestTask *)task didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

@end
