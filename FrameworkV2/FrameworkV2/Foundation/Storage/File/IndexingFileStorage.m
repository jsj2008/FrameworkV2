//
//  IndexingFileStorage.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "IndexingFileStorage.h"

@interface IndexingFileStorage ()

@property (nonatomic, copy) NSString *directory;

@property (nonatomic) NSFileManager *fileManager;

@property (nonatomic) dispatch_queue_t syncQueue;

@end


@implementation IndexingFileStorage

- (void)dealloc
{
    dispatch_sync(self.syncQueue, ^{});
}

- (instancetype)initWithDirectory:(NSString *)directory
{
    if (self = [super init])
    {
        self.directory = directory;
        
        self.fileManager = [[NSFileManager alloc] init];
        
        self.syncQueue = dispatch_queue_create([[NSString stringWithFormat:@"IndexingFileStorage: %@", directory] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        BOOL isDirectory = NO;
        
        if (!([self.fileManager fileExistsAtPath:self.directory isDirectory:&isDirectory] && isDirectory))
        {
            [self.fileManager createDirectoryAtPath:self.directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    return self;
}

- (BOOL)saveData:(NSData *)data forIndex:(NSString *)index
{
    __block BOOL success = NO;
    
    if (self.directory && index && [data length] > 0)
    {
        NSString *dataPath = [self.directory stringByAppendingPathComponent:index];
        
        dispatch_sync(self.syncQueue, ^{
            
            success = [data writeToFile:dataPath atomically:YES];
        });
    }
    
    return success;
}

- (BOOL)saveDataWithPath:(NSString *)path forIndex:(NSString *)index moveOrCopy:(BOOL)moveOrCopy
{
    __block BOOL success = NO;
    
    if (self.directory && index && path)
    {
        NSString *dataPath = [self.directory stringByAppendingPathComponent:index];
        
        dispatch_sync(self.syncQueue, ^{
            
            if (moveOrCopy)
            {
                success = [self.fileManager moveItemAtPath:path toPath:dataPath error:nil];
            }
            else
            {
                success = [self.fileManager copyItemAtPath:path toPath:dataPath error:nil];
            }
        });
    }
    
    return success;
}

- (NSData *)dataForIndex:(NSString *)index
{
    __block NSData *data = nil;
    
    if (self.directory && index)
    {
        NSString *dataPath = [self.directory stringByAppendingPathComponent:index];
        
        dispatch_sync(self.syncQueue, ^{
            
            data = [NSData dataWithContentsOfFile:dataPath];
        });
    }
    
    return data;
}

- (NSDictionary<NSString *,NSData *> *)dataForIndexes:(NSArray<NSString *> *)indexes
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    if (self.directory && [indexes count] > 0)
    {
        dispatch_sync(self.syncQueue, ^{
            
            for (NSString *index in indexes)
            {
                NSString *dataPath = [self.directory stringByAppendingPathComponent:index];
                
                NSData *indexData = [NSData dataWithContentsOfFile:dataPath];
                
                if ([indexData length] > 0)
                {
                    [data setObject:indexData forKey:index];
                }
            }
        });
    }
    
    return [data count] > 0 ? data : nil;
}

- (NSString *)dataPathForIndex:(NSString *)index
{
    return (self.directory && index) ? [self.directory stringByAppendingPathComponent:index] : nil;
}

- (NSArray<NSString *> *)existingDataIndexesInIndexScope:(NSArray<NSString *> *)indexScope
{
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    
    if (self.directory && [indexScope count] > 0)
    {
        dispatch_sync(self.syncQueue, ^{
            
            for (NSString *index in indexScope)
            {
                BOOL isDirectory = NO;
                
                if ([self.fileManager fileExistsAtPath:[self.directory stringByAppendingPathComponent:index] isDirectory:&isDirectory] && !isDirectory)
                {
                    [indexes addObject:index];
                }
            }
        });
    }
    
    return [indexes count] > 0 ? indexes : nil;
}

- (void)removeDataForIndexes:(NSArray<NSString *> *)indexes
{
    if (self.directory && [indexes count] > 0)
    {
        dispatch_sync(self.syncQueue, ^{
            
            for (NSString *index in indexes)
            {
                [self.fileManager removeItemAtPath:[self.directory stringByAppendingPathComponent:index] error:nil];
            }
        });
    }
}

- (void)removeAllDatas
{
    if (self.directory)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NSString *tempDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSDate date] description]];
            
            [self.fileManager moveItemAtPath:self.directory toPath:tempDirectory error:nil];
            
            [self.fileManager createDirectoryAtPath:self.directory withIntermediateDirectories:YES attributes:nil error:nil];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                NSFileManager *fileManager = [[NSFileManager alloc] init];
                
                [fileManager removeItemAtPath:tempDirectory error:nil];
            });
        });
    }
}

- (long long)currentDataSize
{
    __block long long size = 0;
    
    if (self.directory)
    {
        dispatch_sync(self.syncQueue, ^{
            
            size += [[self.fileManager attributesOfItemAtPath:self.directory error:nil] fileSize];
            
            for (NSString *subFileName in [self.fileManager contentsOfDirectoryAtPath:self.directory error:nil])
            {
                NSString *subPath = [self.directory stringByAppendingPathComponent:subFileName];
                
                size += [[self.fileManager attributesOfItemAtPath:subPath error:nil] fileSize];
            }
        });
    }
    
    return size;
}

@end
