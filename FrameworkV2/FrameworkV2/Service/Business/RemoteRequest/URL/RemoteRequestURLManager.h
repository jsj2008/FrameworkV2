//
//  RemoteRequestURLManager.h
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        RemoteRequestURLManager
 
    @abstract
        远端请求URL管理器，所有的远端请求的URL都应当从管理器取得
 
    @discussion
        1，管理器给出的具体请求的URL是NSURLComponents对象，允许使用者自己拼接参数
        2，无特殊说明，管理器给出的具体请求的NSURLComponents对象，应当只配置scheme，host，path三项属性
 
 *********************************************************/

@interface RemoteRequestURLManager : NSObject

/*!
 * @brief 单例
 */
+ (RemoteRequestURLManager *)sharedInstance;

/*!
 * @brief XXX请求
 */
@property (nonatomic, readonly) NSURLComponents *XXXURL;

@end
