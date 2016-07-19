//
//  DBError.h
//  FrameworkV1
//
//  Created by ww on 16/5/13.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

// 数据库错误域
extern NSString * const DBErrorDomain;


/********************** NSError (DB) **********************
 
    @category
        NSError (DB)
 
    @abstract
        DB框架中的错误
 
 ********************** NSError (DB) **********************/

@interface NSError (DB)

/*!
 * @brief 根据错误信息生成错误
 * @param code 错误码
 * @param message 错误信息
 * @result 错误对象
 */
+ (NSError *)DBErrorWithCode:(int)code message:(NSString *)message;

/*!
 * @brief 获取数据库对象的错误
 * @param db 数据库对象
 * @result 错误对象
 */
+ (NSError *)DBErrorWithDB:(sqlite3 *)db;

@end
