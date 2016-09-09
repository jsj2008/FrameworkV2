//
//  ImageDownloadTask.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageDownloadTask.h"
#import "HTTPDownloadConnection.h"
#import "SharedHTTPSessionManager.h"
#import "ImageStorage.h"

@interface ImageDownloadTask () <HTTPDownloadConnectionDelegate>

@property (nonatomic) HTTPDownloadConnection *connection;

- (void)finishWithError:(NSError *)error data:(NSData *)data;

@end


@implementation ImageDownloadTask

- (void)main
{
    if ([self.imageURL isFileURL])
    {
        [self finishWithError:nil data:[NSData dataWithContentsOfURL:self.imageURL]];
    }
    else
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3 * 60];
        
        self.connection = [[HTTPDownloadConnection alloc] initWithRequest:request session:[SharedHTTPSessionManager sharedInstance].defaultConfigurationSession];
        
        self.connection.delegate = self;
        
        [self.connection start];
    }
}

- (void)cancel
{
    [super cancel];
    
    self.connection.delegate = nil;
    
    [self.connection cancel];
    
    self.connection = nil;
}

- (void)finishWithError:(NSError *)error data:(NSData *)data
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageDownloadTask:didFinishWithError:data:)])
        {
            [self.delegate imageDownloadTask:self didFinishWithError:error data:data];
        }
        
    } onThread:self.notifyThread];
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishDownloadingToURL:(NSURL *)location error:(NSError *)error
{
    if (error)
    {
        [self finishWithError:error data:nil];
    }
    else
    {
        NSError *saveError = nil;
        
        NSData *data = location ? [NSData dataWithContentsOfURL:location] : nil;
        
        [[ImageStorage sharedInstance] saveImageByURL:self.imageURL withDataPath:location.path error:&saveError];
        
        [self finishWithError:saveError data:saveError ? nil : data];
    }
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response
{
    [self finishWithError:error data:nil];
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self notify:^{
        
        if ([self.delegate respondsToSelector:@selector(imageDownloadTask:didDownloadImageWithDownloadedSize:expectedSize:)])
        {
            [self.delegate imageDownloadTask:self didDownloadImageWithDownloadedSize:totalBytesWritten expectedSize:totalBytesExpectedToWrite];
        }
        
    } onThread:self.notifyThread];
}

@end
