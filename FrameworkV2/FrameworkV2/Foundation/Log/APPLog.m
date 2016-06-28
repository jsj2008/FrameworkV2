//
//  APPLog.m
//  FoundationProject
//
//  Created by user on 13-12-10.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "APPLog.h"
#import "LogFileHandle.h"

@interface APPLog ()
{
    // 停止标志
    BOOL _stop;
}

/*!
 * @brief 文件打印句柄
 */
@property (nonatomic) LogFileHandle *fileHandle;

@end


@implementation APPLog

- (id)init
{
    if (self = [super init])
    {
        _stop = YES;
        
        self.enableNSLog = YES;
        
        self.enableFileLog = YES;
    }
    
    return self;
}

- (void)start
{
    _stop = NO;
    
    self.fileHandle = [[LogFileHandle alloc] initWithRootDirectory:self.logFileDirectory];
}

- (void)stop
{
    _stop = YES;
    
    self.fileHandle = nil;
}

- (void)cleanAllLog
{
    [self.fileHandle cleanAllLog];
}

- (void)cleanLogAtPath:(NSString *)path
{
    [self.fileHandle cleanLogAtPath:path];
}

- (void)resetLogs
{
    [self.fileHandle resetLogs];
}

- (NSArray *)currentAllLogPathes
{
    return [self.fileHandle currentAllLogPathes];
}

- (void)logString:(NSString *)string
{
    if (!_stop)
    {
        if (self.isNSLogEnabled)
        {
            NSLog(@"%@", string);
        }
        
        if (self.isFileLogEnabled)
        {
            [self.fileHandle writeString:string];
        }
    }
}

@end
