//
//  DBError.h
//  FrameworkV1
//
//  Created by ww on 16/5/13.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

extern NSString * const DBErrorDomain;


@interface NSError (DB)

+ (NSError *)DBErrorWithCode:(int)code message:(NSString *)message;

+ (NSError *)DBErrorWithDB:(sqlite3 *)db;

@end
