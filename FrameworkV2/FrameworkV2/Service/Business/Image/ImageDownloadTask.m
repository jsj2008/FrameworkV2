//
//  ImageDownloadTask.m
//  FrameworkV1
//
//  Created by ww on 16/5/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "ImageDownloadTask.h"
#import "ImageManager.h"

@interface ImageDownloadTask () <ImageManagerDelegate>
{
    NSURL *_URL;
}

- (void)finishWithError:(NSError *)error imageData:(NSData *)data;

@end


@implementation ImageDownloadTask

@synthesize URL = _URL;

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        _URL = [URL copy];
    }
    
    return self;
}

- (void)run
{
    [[ImageManager sharedInstance] downLoadImageByURL:self.URL withObserver:self];
}

- (void)cancel
{
    [super cancel];
    
    [[ImageManager sharedInstance] cancelDownLoadImageByURL:self.URL withObserver:self];
}

- (void)finishWithError:(NSError *)error imageData:(NSData *)data
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloadTask:didFinishWithError:imageData:)])
        {
            [self.delegate imageDownloadTask:self didFinishWithError:error imageData:data];
        }
    } onThread:self.notifyThread];
}

- (void)imageManager:(ImageManager *)manager didFinishDownloadImageByURL:(NSURL *)URL withError:(NSError *)error imageData:(NSData *)data
{
    [self finishWithError:error imageData:data];
}

- (void)imageManager:(ImageManager *)manager didDownloadImageByURL:(NSURL *)URL withDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloadTask:didDownloadImageWithDownloadedSize:expectedSize:)])
        {
            [self.delegate imageDownloadTask:self didDownloadImageWithDownloadedSize:downloadedSize expectedSize:expectedSize];
        }
    } onThread:self.notifyThread];
}

@end
