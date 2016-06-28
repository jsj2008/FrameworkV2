//
//  APPLog+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "APPLog.h"

/*********************************************************
 
    @category
        APPLog (SharedInstance)
 
    @abstract
        APPLog的单例扩展
 
 *********************************************************/

@interface APPLog (SharedInstance)

/*!
 * @brief 单例
 */
+ (APPLog *)sharedInstance;

@end
