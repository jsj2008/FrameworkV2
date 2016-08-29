//
//  UBImageLoader.m
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBImageLoader.h"
#import "ImageManager.h"
#import "AsyncTaskDispatcher.h"

@interface UBImageLoader () <ImageManagerDelegate>
{
    NSURL *_URL;
}

@property (nonatomic) AsyncTaskDispatcher *taskDispatcher;

- (void)finishWithError:(NSError *)error imageData:(NSData *)data;

@end


@implementation UBImageLoader

@synthesize URL = _URL;

- (void)dealloc
{
    [[ImageManager sharedInstance] cancelDownLoadImageByURL:self.URL withObserver:self];
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
    [[ImageManager sharedInstance] downLoadImageByURL:self.URL withObserver:self];
}

- (void)cancel
{
    [[ImageManager sharedInstance] cancelDownLoadImageByURL:self.URL withObserver:self];
}

- (void)imageManager:(ImageManager *)manager didFinishDownloadImageByURL:(NSURL *)URL withError:(NSError *)error imageData:(NSData *)data
{
    if ([URL isEqual:self.URL])
    {
        [self finishWithError:error imageData:data];
    }
}

- (void)imageManager:(ImageManager *)manager didDownloadImageByURL:(NSURL *)URL withDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    if ([URL isEqual:self.URL] && self.delegate && [self.delegate respondsToSelector:@selector(imageLoader:didDownloadImageWithDownloadedSize:expectedSize:)])
    {
        [self.delegate imageLoader:self didDownloadImageWithDownloadedSize:downloadedSize expectedSize:expectedSize];
    }
}

- (void)finishWithError:(NSError *)error imageData:(NSData *)data
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageLoader:didFinishWithError:imageData:)])
    {
        [self.delegate imageLoader:self didFinishWithError:error imageData:data];
    }
}

@end
