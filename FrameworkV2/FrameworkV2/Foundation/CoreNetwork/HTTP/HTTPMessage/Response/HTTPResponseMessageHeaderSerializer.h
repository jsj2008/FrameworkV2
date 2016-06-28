//
//  HTTPResponseMessageHeaderSerializer.h
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageSerializer.h"
#import "HTTPResponseHeader.h"

/******************************************************
 
    @class
        HTTPResponseMessageHeaderSerializer
 
    @abstract
        HTTP响应报文头部序列化器
 
 ******************************************************/

@interface HTTPResponseMessageHeaderSerializer : HTTPMessageSerializer

/*!
 * @brief 初始化
 * @param responseHeader 响应头
 * @result 初始化后的对象
 */
- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader;

@end
