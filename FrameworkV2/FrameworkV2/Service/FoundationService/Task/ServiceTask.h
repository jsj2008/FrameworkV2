//
//  ServiceTask.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "DispatchableTask.h"

/*********************************************************
 
    @class
        ServiceTask
 
    @abstract
        操作任务，具体任务的公共父类
 
 *********************************************************/

@interface ServiceTask : DispatchableTask

/*!
 * @brief 用户字典，仅用于传递，内部不进行任何处理
 */
@property (nonatomic) NSDictionary *userInfo;

@end
