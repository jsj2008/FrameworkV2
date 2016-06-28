//
//  HTTPConnectionResumeStorage+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/5/3.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPConnectionResumeStorage.h"

/*********************************************************
 
    @category
        HTTPConnectionResumeStorage (SharedInstance)
 
    @abstract
        HTTPConnectionResumeStorage的单例扩展
 
 *********************************************************/


@interface HTTPConnectionResumeStorage (SharedInstance)

/*!
 * @brief 单例
 */
+ (HTTPConnectionResumeStorage *)sharedInstance;

@end
