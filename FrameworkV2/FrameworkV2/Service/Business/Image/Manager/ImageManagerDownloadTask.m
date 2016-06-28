//
//  ImageManagerDownloadTask.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/14/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageManagerDownloadTask.h"
#import "HTTPDownloadConnection.h"
#import "SharedHTTPSessionManager.h"

@interface ImageManagerDownloadTask () <HTTPDownloadConnectionDelegate>

@property (nonatomic) HTTPDownloadConnection *connection;

@property (nonatomic) NSData *data;

- (void)finishWithError:(NSError *)error;

@end


@implementation ImageManagerDownloadTask

- (void)run
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3 * 60];
    
    self.connection = [[HTTPDownloadConnection alloc] initWithRequest:request session:[SharedHTTPSessionManager sharedInstance].defaultConfigurationSession];
    
    self.connection.delegate = self;
    
    [self.connection start];
}

- (void)cancel
{
    [super cancel];
    
    self.connection.delegate = nil;
    
    [self.connection cancel];
    
    self.connection = nil;
}

- (void)finishWithError:(NSError *)error
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageManagerDownloadTask:didFinishWithError:)])
        {
            [self.delegate imageManagerDownloadTask:self didFinishWithError:error];
        }
    } onThread:self.notifyThread];
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishDownloadingToURL:(NSURL *)location error:(NSError *)error
{
    if (error)
    {
        [self finishWithError:error];
    }
    else if (location)
    {
        NSError *error = nil;
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if ((![fileManager moveItemAtURL:location toURL:self.resourceURL error:&error]))
        {
            [self finishWithError:error];
        }
    }
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didFinishWithError:(NSError *)error response:(NSHTTPURLResponse *)response
{
    [self finishWithError:error];
}

- (void)HTTPDownloadConnection:(HTTPDownloadConnection *)downloadConnection didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    [self notify:^{
        
        if ([self.delegate respondsToSelector:@selector(imageManagerDownloadTask:didDownloadImageWithDownloadedSize:expectedSize:)])
        {
            [self.delegate imageManagerDownloadTask:self didDownloadImageWithDownloadedSize:totalBytesWritten expectedSize:totalBytesExpectedToWrite];
        }
    } onThread:self.notifyThread];
}

@end
