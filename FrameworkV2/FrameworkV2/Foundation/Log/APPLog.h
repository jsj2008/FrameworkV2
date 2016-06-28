//
//  APPLog.h
//  FoundationProject
//
//  Created by user on 13-12-10.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        APPLog
 
    @abstract
        日志系统，管理日志打印等
 
 *********************************************************/

@interface APPLog : NSObject

/*!
 * @brief log文件目录
 */
@property (nonatomic, copy) NSString *logFileDirectory;

/*!
 * @brief 是否启用NSLog
 */
@property (nonatomic, getter=isNSLogEnabled) BOOL enableNSLog;

/*!
 * @brief 是否启用文件log
 */
@property (nonatomic, getter=isFileLogEnabled) BOOL enableFileLog;

/*!
 * @brief 启动日志
 */
- (void)start;

/*!
 * @brief 关闭日志，关闭后无法对日志进行任何操作
 */
- (void)stop;

/*!
 * @brief 清理日志
 * @discussion 清理工作将清除所有日志的相关数据
 */
- (void)cleanAllLog;

/*!
 * @brief 清理指定文件日志
 * @param path 日志路径
 */
- (void)cleanLogAtPath:(NSString *)path;

/*!
 * @brief 重置文件日志
 * @discussion 重置操作将新建日志文件作为当前操作文件
 */
- (void)resetLogs;

/*!
 * @brief 当前所有日志文件路径
 * @result 日志文件路径
 */
- (NSArray *)currentAllLogPathes;

/*!
 * @brief 按照默认日志等级打印日志
 * @param string 日志字符串
 */
- (void)logString:(NSString *)string;

@end
