//
//  HTTPRequestResponseJsonContent.h
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestResponseContent.h"

/*********************************************************
 
    @class
        HTTPRequestResponseJsonContent
 
    @abstract
        HTTP请求的Json响应内容
 
 *********************************************************/

@interface HTTPRequestResponseJsonContent : HTTPRequestResponseContent

/*!
 * @brief 解析json节点
 * @discussion 正确解析，需满足条件：1，请求返回无错误信息；2，状态码200；3，MIME类型范围@"application/json", @"text/json", @"text/javascript", @"application/javascript"；4，编码类型UTF8
 * @param error 错误信息
 * @result json节点
 */
- (id)jsonNodeWithError:(NSError **)error;

@end
