//
//  HTTPRequestBody.h
//  FrameworkV1
//
//  Created by ww on 16/5/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPUploadConnection.h"

/*********************************************************
 
    @class
        HTTPRequestBody
 
    @abstract
        HTTP请求体
 
 *********************************************************/

@interface HTTPRequestBody : NSObject

/*!
 * @brief body类型，用于配置HTTP的Content-Type首部
 */
@property (nonatomic, copy) NSString *contentType;

/*!
 * @brief 生成上传连接
 * @param request 请求
 * @param session 会话
 * @result 上传连接
 */
- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session;

@end


/*********************************************************
 
    @class
        HTTPRequestDataBody
 
    @abstract
        HTTP数据块请求体
 
 *********************************************************/

@interface HTTPRequestDataBody : HTTPRequestBody

/*!
 * @brief 数据块
 */
@property (nonatomic) NSData *data;

@end


/*********************************************************
 
    @class
        HTTPRequestFileBody
 
    @abstract
        HTTP文件请求体
 
 *********************************************************/

@interface HTTPRequestFileBody : HTTPRequestBody

/*!
 * @brief 文件URL
 */
@property (nonatomic, copy) NSURL *fileURL;

@end


/*********************************************************
 
    @class
        HTTPRequestStreamBody
 
    @abstract
        HTTP数据流请求体
 
 *********************************************************/

@interface HTTPRequestStreamBody : HTTPRequestBody

/*!
 * @brief 数据流
 */
@property (nonatomic) HTTPConnectionInputStream *stream;

@end
