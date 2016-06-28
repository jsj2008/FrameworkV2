//
//  HTTPConnectionResumeStorage.h
//  Test1
//
//  Created by ww on 16/4/13.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        HTTPConnectionResumeStorage
 
    @abstract
        HTTP断点续传信息存储器
 
 *********************************************************/

@interface HTTPConnectionResumeStorage : NSObject

/*!
 * @brief 初始化
 * @param diskPath 磁盘位置，存储器将在此位置建立文件夹存储数据，若文件夹不存在，将自动创建
 * @result 初始化后的对象
 */
- (instancetype)initWithDiskPath:(NSString *)diskPath;

/*!
 * @brief 保存数据
 * @param data 断点续传数据
 * @param request 请求对象
 */
- (void)saveResumeData:(NSData *)data forRequest:(NSURLRequest *)request;

/*!
 * @brief 读取数据
 * @param request 请求对象
 * @result 断点续传对象
 */
- (NSData *)resumeDataForRequest:(NSURLRequest *)request;

@end
