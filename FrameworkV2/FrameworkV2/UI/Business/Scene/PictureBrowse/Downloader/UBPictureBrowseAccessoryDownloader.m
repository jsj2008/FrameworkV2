//
//  UBPictureBrowseAccessoryDownloader.m
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPictureBrowseAccessoryDownloader.h"
#import "UBImageLoader.h"
#import "AsyncTaskDispatcher.h"

static NSString * const kTaskUserInfoKey_Picture = @"picture";


@interface UBPictureBrowseAccessoryDownloader () <UBImageLoaderDelegate>

@property (nonatomic) NSMutableArray<UBImageLoader *> *imageLoaders;

@end


@implementation UBPictureBrowseAccessoryDownloader

- (void)dealloc
{
    [self cancel];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.imageLoaders = [[NSMutableArray alloc] init];
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
    
    for (UBImageLoader *imageLoader in self.imageLoaders)
    {
        if ([imageLoader.URL isEqual:picture.URL])
        {
            exist = YES;
            
            break;
        }
    }
    
    if (!exist)
    {
        if (self.imageLoaders.count >= self.maxConcurrentDownloadCount)
        {
            UBImageLoader *imageLoader = [self.imageLoaders firstObject];
            
            if (imageLoader)
            {
                [imageLoader cancel];
                
                [self.imageLoaders removeObjectAtIndex:0];
            }
        }
        
        UBImageLoader *imageLoader = [[UBImageLoader alloc] initWithURL:picture.URL];
        
        imageLoader.delegate = self;
        
        imageLoader.userInfo = [NSDictionary dictionaryWithObject:picture forKey:kTaskUserInfoKey_Picture];
        
        [self.imageLoaders addObject:imageLoader];
        
        [imageLoader start];
    }
}

- (void)cancel
{
    for (UBImageLoader *imageLoader in self.imageLoaders)
    {
        [imageLoader cancel];
    }
    
    [self.imageLoaders removeAllObjects];
}

- (void)imageLoader:(UBImageLoader *)imageLoader didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    if (error)
    {
        UBPictureBrowseURLPicture *picture = [imageLoader.userInfo objectForKey:kTaskUserInfoKey_Picture];
        
        picture.downloadError = error;
    }
}

@end
