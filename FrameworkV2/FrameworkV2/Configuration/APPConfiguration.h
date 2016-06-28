//
//  APPConfiguration.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        APPConfiguration
 
    @abstract
        APP配置
 
 *********************************************************/

@interface APPConfiguration : NSObject

/*!
 * @brief 单例
 * @result APPConfiguration全局对象
 */
+ (APPConfiguration *)sharedInstance;

#pragma mark - File directory

/*!
 * @brief app日志目录，默认$cache/APPLog
 */
@property (atomic, copy) NSString *appLogDirectory;

/*!
 * @brief 图片目录，默认$cache/Image
 */
@property (atomic, copy) NSString *imageDirectory;

@end
