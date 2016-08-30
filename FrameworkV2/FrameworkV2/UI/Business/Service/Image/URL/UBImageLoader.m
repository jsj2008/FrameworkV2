//
//  UBImageLoader.m
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBImageLoader.h"
#import "UBImageDownloadManager.h"
#import "ImageStorage.h"

@interface UBImageLoader () <ImageManagerDelegate>

- (void)finishWithError:(NSError *)error imageData:(NSData *)data;

@end


@implementation UBImageLoader

- (void)dealloc
{
    [[UBImageDownloadManager sharedInstance] cancelDownLoadImageByURL:self.URL withObserver:self];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        _URL = [URL copy];
        
        self.enableLocalImage = YES;
    }
    
    return self;
}

- (void)start
{
    if (self.enableLocalImage)
    {
        NSData *imageData = [[ImageStorage sharedInstance] imageDataByURL:self.URL];
        
        if (imageData)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self finishWithError:nil imageData:imageData];
            });
        }
        else
        {
            [[UBImageDownloadManager sharedInstance] downLoadImageByURL:self.URL withObserver:self];
        }
    }
    else
    {
        [[UBImageDownloadManager sharedInstance] downLoadImageByURL:self.URL withObserver:self];
    }
}

- (void)cancel
{
    [[UBImageDownloadManager sharedInstance] cancelDownLoadImageByURL:self.URL withObserver:self];
}

- (void)imageManager:(UBImageDownloadManager *)manager didFinishDownloadImageByURL:(NSURL *)URL withError:(NSError *)error imageData:(NSData *)data
{
    if ([URL isEqual:self.URL])
    {
        [self finishWithError:error imageData:data];
    }
}

- (void)imageManager:(UBImageDownloadManager *)manager didDownloadImageByURL:(NSURL *)URL withDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
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
