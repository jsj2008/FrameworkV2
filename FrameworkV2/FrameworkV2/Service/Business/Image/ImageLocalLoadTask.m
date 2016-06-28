//
//  ImageLocalLoadTask.m
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "ImageLocalLoadTask.h"
#import "ImageManager.h"

@interface ImageLocalLoadTask ()
{
    NSURL *_URL;
}

- (void)finishWithError:(NSError *)error imageData:(NSData *)data;

@end


@implementation ImageLocalLoadTask

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
    NSData *data = [[ImageManager sharedInstance] localImageDataForURL:self.URL];
    
    [self finishWithError:nil imageData:data];
}

- (void)finishWithError:(NSError *)error imageData:(NSData *)data
{
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageLocalLoadTask:didFinishWithError:imageData:)])
        {
            [self.delegate imageLocalLoadTask:self didFinishWithError:error imageData:data];
        }
        
    } onThread:self.notifyThread];
}

@end
