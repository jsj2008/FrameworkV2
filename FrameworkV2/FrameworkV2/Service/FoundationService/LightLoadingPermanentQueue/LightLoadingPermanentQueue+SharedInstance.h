//
//  LightLoadingPermanentQueue+SharedInstance.h
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "LightLoadingPermanentQueue.h"

/*********************************************************
 
    @category
        LightLoadingPermanentQueue (SharedInstance)
 
    @abstract
        LightLoadingPermanentQueue的单例扩展
 
 *********************************************************/

@interface LightLoadingPermanentQueue (SharedInstance)

/*!
 * @brief 单例
 */
+ (LightLoadingPermanentQueue *)sharedInstance;

@end
