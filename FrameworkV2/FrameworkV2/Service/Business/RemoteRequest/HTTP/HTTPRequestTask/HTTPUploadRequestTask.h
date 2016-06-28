//
//  HTTPUploadRequestTask.h
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestTask.h"
#import "HTTPRequestBody.h"

/*********************************************************
 
    @class
        HTTPUploadRequestTask
 
    @abstract
        HTTP上传请求Task
 
 *********************************************************/

@interface HTTPUploadRequestTask : HTTPRequestTask

/*!
 * @brief 上传数据
 */
@property (nonatomic) HTTPRequestBody *uploadBody;

@end


/*********************************************************
 
    @protocol
        HTTPUploadRequestTaskDelegate
 
    @abstract
        HTTP上传请求Task的代理协议
 
 *********************************************************/

@protocol HTTPUploadRequestTaskDelegate <NSObject>

/*!
 * @brief 请求结束
 * @param task 请求Task
 * @param error 错误信息
 * @param response 响应信息
 * @param data 响应数据
 */
- (void)HTTPUploadRequestTask:(HTTPUploadRequestTask *)task didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data;

@optional

/*!
 * @brief 上传进度通知
 * @param task 请求Task
 * @param bytesSent 两次通知间的发送量
 * @param totalBytesSent 已发送总量
 * @param totalBytesExpectedToSend 期望发送总量（资源大小）
 */
- (void)HTTPUploadRequestTask:(HTTPUploadRequestTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;

@end
