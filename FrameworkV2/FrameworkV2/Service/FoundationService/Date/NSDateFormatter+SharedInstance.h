//
//  NSDateFormatter+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @category
        NSDateFormatter (SharedInstance)
 
    @abstract
        NSDateFormatter的单例扩展
 
    @discussion
        1，NSDateFormatter的创建是非常耗时的，应当使用单例减小开销
 
 *********************************************************/

@interface NSDateFormatter (SharedInstance)

@end
