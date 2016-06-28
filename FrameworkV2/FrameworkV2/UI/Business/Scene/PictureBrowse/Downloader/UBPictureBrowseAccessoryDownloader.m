//
//  UBPictureBrowseAccessoryDownloader.m
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPictureBrowseAccessoryDownloader.h"
#import "ImageDownloadTask.h"
#import "AsyncTaskDispatcher.h"

static NSString * const kTaskUserInfoKey_Picture = @"picture";


@interface UBPictureBrowseAccessoryDownloader () <ImageDownloadTaskDelegate>

@property (nonatomic) NSMutableArray<ImageDownloadTask *> *downloadTasks;

@property (nonatomic) AsyncTaskDispatcher *taskDispatcher;

@end


@implementation UBPictureBrowseAccessoryDownloader

- (void)dealloc
{
    [self.taskDispatcher cancel];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.downloadTasks = [[NSMutableArray alloc] init];
        
        self.taskDispatcher = [[AsyncTaskDispatcher alloc] init];
    }
    
    return self;
}

- (void)downloadPicture:(UBPictureBrowseURLPicture *)picture
{
    if (!picture || !picture.URL)
    {
        return;
    }
    
    BOOL exist = NO;
    
    for (ImageDownloadTask *task in self.downloadTasks)
    {
        if ([task.URL isEqual:picture.URL])
        {
            exist = YES;
            
            break;
        }
    }
    
    if (!exist)
    {
        if (self.downloadTasks.count >= self.maxConcurrentDownloadCount)
        {
            ImageDownloadTask *task = [self.downloadTasks firstObject];
            
            if (task)
            {
                [self.taskDispatcher cancelTask:task];
                
                [self.downloadTasks removeObjectAtIndex:0];
            }
        }
        
        ImageDownloadTask *task = [[ImageDownloadTask alloc] initWithURL:picture.URL];
        
        task.delegate = self;
        
        task.userInfo = [NSDictionary dictionaryWithObject:picture forKey:kTaskUserInfoKey_Picture];
        
        [self.taskDispatcher addTask:task];
        
        [self.downloadTasks addObject:task];
    }
}

- (void)cancel
{
    [self.taskDispatcher cancel];
    
    [self.downloadTasks removeAllObjects];
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    if (error)
    {
        UBPictureBrowseURLPicture *picture = [task.userInfo objectForKey:kTaskUserInfoKey_Picture];
        
        picture.downloadError = error;
    }
}

@end
