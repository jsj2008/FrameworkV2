//
//  DBError.m
//  FrameworkV1
//
//  Created by ww on 16/5/13.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "DBError.h"

NSString * const DBErrorDomain = @"DB";


@implementation NSError (DB)

+ (NSError *)DBErrorWithCode:(int)code message:(NSString *)message
{
    return [NSError errorWithDomain:DBErrorDomain code:code userInfo:message ? [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey] : nil];
}

+ (NSError *)DBErrorWithDB:(sqlite3 *)db
{
    const char *msg = sqlite3_errmsg(db);
    
    return [NSError errorWithDomain:DBErrorDomain code:sqlite3_errcode(db) userInfo:msg ? [NSDictionary dictionaryWithObject:[NSString stringWithUTF8String:msg] forKey:NSLocalizedDescriptionKey] : nil];
}

@end
