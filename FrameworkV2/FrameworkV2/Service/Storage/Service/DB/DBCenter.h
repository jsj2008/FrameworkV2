//
//  DBCenter.h
//  FrameworkV1
//
//  Created by ww on 16/5/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        DBCenter
 
    @abstract
        数据库中心
 
    @discussion
        1，所有的数据库数据操作都应当通过数据库中心进行
 
 *********************************************************/

@interface DBCenter : NSObject

/*!
 * @brief 单例
 */
+ (DBCenter *)sharedInstance;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 关闭
 */
- (void)stop;

@end
