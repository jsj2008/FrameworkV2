//
//  HTTPTrailer.h
//  HS
//
//  Created by ww on 16/5/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @class
        HTTPTrailer
 
    @abstract
        HTTP拖挂
 
 ******************************************************/

@interface HTTPTrailer : NSObject

/*!
 * @brief 拖挂首部
 */
@property (nonatomic) NSDictionary *headerFields;

@end
