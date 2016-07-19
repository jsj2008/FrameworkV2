//
//  XXXRequestResponseJsonContent.h
//  FrameworkV2
//
//  Created by ww on 16/7/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestResponseJsonContent.h"

/*********************************************************
 
    @class
        XXXRequestResponseJsonContent
 
    @abstract
        XXX请求的Json响应内容
 
 *********************************************************/

@interface XXXRequestResponseJsonContent : HTTPRequestResponseJsonContent

/*!
 * @brief 解析数据节点
 * @param error 错误信息
 * @result json节点
 */
- (NSDictionary *)dataNodeWithError:(NSError **)error;

@end
