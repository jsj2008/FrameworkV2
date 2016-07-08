//
//  HTTPConnectionResumeStorage.m
//  Test1
//
//  Created by ww on 16/4/13.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnectionResumeStorage.h"

@interface HTTPConnectionResumeStorage ()

@property (nonatomic, copy) NSString *diskDirectory;

@property (nonatomic) dispatch_queue_t syncQueue;

@end


@implementation HTTPConnectionResumeStorage

- (void)dealloc
{
    dispatch_sync(self.syncQueue, ^{});
}

- (instancetype)initWithDiskPath:(NSString *)diskPath
{
    if (self = [super init])
    {
        self.diskDirectory = diskPath;
        
        self.syncQueue = dispatch_queue_create([[NSString stringWithFormat:@"HTTPConnectionResumeStorage: %@", diskPath] UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        BOOL isDirectory = NO;
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if (!([fileManager fileExistsAtPath:diskPath isDirectory:&isDirectory] && isDirectory))
        {
            [fileManager createDirectoryAtPath:diskPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    return self;
}

- (void)saveResumeData:(NSData *)data forRequest:(NSURLRequest *)request
{
    NSString *index = [[[request.URL absoluteString] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    dispatch_sync(self.syncQueue, ^{
        
        [data writeToFile:[self.diskDirectory stringByAppendingPathComponent:index] atomically:YES];
        
    });
}

- (NSData *)resumeDataForRequest:(NSURLRequest *)request
{
    NSString *index = [[[request.URL absoluteString] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    
    __block NSData *data = nil;
    
    dispatch_sync(self.syncQueue, ^{
        
        data = [NSData dataWithContentsOfFile:[self.diskDirectory stringByAppendingPathComponent:index]];
    });
    
    return data;
}

@end
