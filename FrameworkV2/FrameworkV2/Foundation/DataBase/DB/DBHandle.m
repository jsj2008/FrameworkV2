//
//  DBHandle.m
//  DB
//
//  Created by w w on 13-6-30.
//  Copyright (c) 2013年 w w. All rights reserved.
//

#import "DBHandle.h"
#import "DBMachine.h"
#import "DBSQL.h"

/********************** DBHandle **********************/

#pragma mark - DBHandle

@interface DBHandle ()
{
    // 同步队列
    dispatch_queue_t _syncQueue;
}

@end


@implementation DBHandle

- (void)dealloc
{
    dispatch_sync(_syncQueue, ^{});
}

- (id)init
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create("DB handle", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (id)initWithPath:(NSString *)path
{
    if (self = [super init])
    {
        _syncQueue = dispatch_queue_create([[NSString stringWithFormat:@"DB handle: %@", path] UTF8String], NULL);
        
        _machine = [[DBMachine alloc] initWithFile:path];
    }
    
    return self;
}

- (void)startWithError:(NSError *__autoreleasing *)error
{
    *error = nil;
    
    dispatch_sync(_syncQueue, ^{
        
        [_machine startWithError:error];
        
        if (error && _machine)
        {
            _machine = nil;
        }
    });
}

- (void)updateDBByExecutingSQLs:(NSArray<NSString *> *)sqls error:(NSError *__autoreleasing *)error
{
    *error = nil;
    
    if (!_machine)
    {
        return;
    }
    
    if ([sqls count] > 0)
    {
        dispatch_sync(_syncQueue, ^{
            
            if ([sqls count] == 1)
            {
                [_machine executeSQL:[sqls objectAtIndex:0] error:error];
            }
            else
            {
                [_machine commitTransactionBlock:^{
                    
                    for (NSString *sql in sqls)
                    {
                        [_machine executeSQL:sql error:error];
                    }
                } error:error];
            }
        });
    }
}

- (void)updateDBByBindingSQL:(NSString *)unbindSQL withFields:(NSArray<DBTableField *> *)fields records:(NSArray *)records error:(NSError *__autoreleasing *)error
{
    *error = nil;
    
    if (!_machine)
    {
        return;
    }
    
    if ([records count] > 0)
    {
        dispatch_sync(_syncQueue, ^{
            
            BOOL (^exe)(NSString *, NSArray *, NSArray *) = ^(NSString *sql, NSArray *fields, NSArray *records){
                
                BOOL success = YES;
                
                sqlite3_stmt *statement = NULL;
                
                if ((statement = [_machine preparedStatementForSQL:unbindSQL error:error]))
                {
                    for (NSDictionary *record in records)
                    {
                        for (int i = 0; i < [fields count]; i ++)
                        {
                            DBTableField *field = [fields objectAtIndex:i];
                            
                            [_machine bindValue:[record objectForKey:field.name] byType:field.type toPreparedStatement:statement inLocation:(i + 1) error:error];
                        }
                        
                        [_machine stepStatement:statement error:error];
                        
                        [_machine resetStatement:statement error:error];
                    }
                }
                
                [_machine finalizeStatement:statement error:error];
                
                return success;
            };
            
            if ([records count] == 1)
            {
                exe(unbindSQL, fields, records);
            }
            else
            {
                [_machine commitTransactionBlock:^{
                    
                    exe(unbindSQL, fields, records);
                    
                } error:error];
            }
        });
    }
}

- (NSArray<NSDictionary<NSString *,id> *> *)selectRecordsInFields:(NSArray<DBTableField *> *)fields bySQL:(NSString *)sql error:(NSError *__autoreleasing *)error
{
    NSMutableArray *records = [NSMutableArray array];
    
    NSMutableDictionary *fieldsDic = [NSMutableDictionary dictionary];
    
    for (DBTableField *field in fields)
    {
        if ([field.name length])
        {
            [fieldsDic setObject:field forKey:field.name];
        }
    }
    
    if (_machine && [fields count] && sql)
    {
        dispatch_sync(_syncQueue, ^{
            
            sqlite3_stmt *statement = NULL;
            
            if ((statement = [_machine preparedStatementForSQL:sql error:error]))
            {
                while ([_machine stepStatement:statement error:error] == SQLITE_ROW)
                {
                    NSMutableDictionary *record = [NSMutableDictionary dictionary];
                    
                    int count = [_machine columnDataCountOfPreparedStatement:statement];
                    
                    for (int i = 0; i < count; i ++)
                    {
                        NSString *name = [_machine columnNameOfPreparedStatement:statement inLocation:i];
                        
                        if ([[fieldsDic allKeys] containsObject:name])
                        {
                            id value = [_machine columnValueFromPreparedStatement:statement inLocation:i inType:((DBTableField *)[fieldsDic objectForKey:name]).type];
                            
                            if (value)
                            {
                                [record setObject:value forKey:name];
                            }
                        }
                    }
                    
                    [records addObject:record];
                }
            }
            
            [_machine finalizeStatement:statement error:error];
        });
    }
    
    return [records count] ? records : nil;
}

- (int)selectRecordCountBySQL:(NSString *)sql error:(NSError *__autoreleasing *)error
{
    __block int count = 0;
    
    if (_machine && sql)
    {
        dispatch_sync(_syncQueue, ^{
            
            sqlite3_stmt *statement = NULL;
            
            if ((statement = [_machine preparedStatementForSQL:sql error:error]))
            {
                while ([_machine stepStatement:statement error:error] == SQLITE_ROW)
                {
                    NSNumber *value = [_machine columnValueFromPreparedStatement:statement inLocation:0 inType:DBValueType_Int];
                    
                    if (value)
                    {
                        count = [value intValue];
                    }
                }
                
                [_machine finalizeStatement:statement error:error];
            }
        });
    }
    
    return count;
}

@end
