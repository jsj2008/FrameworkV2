//
//  UBImageViewImageLoader.m
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBImageViewImageLoader.h"
#import "ImageDownloadTask.h"
#import "AsyncTaskDispatcher.h"

@interface UBImageViewImageLoader () <ImageDownloadTaskDelegate>
{
    NSURL *_URL;
}

@property (nonatomic) AsyncTaskDispatcher *taskDispatcher;

- (void)finishWithError:(NSError *)error imageData:(NSData *)data;

@end


@implementation UBImageViewImageLoader

@synthesize URL = _URL;

- (void)dealloc
{
    [self.taskDispatcher cancel];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        _URL = [URL copy];
        
        self.taskDispatcher = [[AsyncTaskDispatcher alloc] init];
    }
    
    return self;
}

- (void)start
{
    ImageDownloadTask *task = [[ImageDownloadTask alloc] initWithURL:self.URL];
    
    task.delegate = self;
    
    [self.taskDispatcher addTask:task];
}

- (void)cancel
{
    [self.taskDispatcher cancel];
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    [self.taskDispatcher removeTask:task];
    
    [self finishWithError:error imageData:data];
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewImageLoader:didDownloadImageWithDownloadedSize:expectedSize:)])
    {
        [self.delegate imageViewImageLoader:self didDownloadImageWithDownloadedSize:downloadedSize expectedSize:expectedSize];
    }
}

- (void)finishWithError:(NSError *)error imageData:(NSData *)data
{
    [self cancel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewImageLoader:didFinishWithError:imageData:)])
    {
        [self.delegate imageViewImageLoader:self didFinishWithError:error imageData:data];
    }
}

@end
