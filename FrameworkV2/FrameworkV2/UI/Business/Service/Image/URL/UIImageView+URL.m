//
//  UIImageView+URL.m
//  FrameworkV1
//
//  Created by ww on 16/5/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UIImageView+URL.h"
#import <objc/runtime.h>
#import "UBImageLoader.h"

static const char kUIImageViewPropertyKey_URLLoadingConfiguration[] = "URLLoadingConfiguration";

static const char kUIImageViewPropertyKey_URLImageLoader[] = "URLImageLoader";


@interface UIImageView (URL_Internal) <UBImageLoaderDelegate>

@property (nonatomic) UBImageLoader *URLImageLoader;

@end


@implementation UIImageView (URL)

- (void)setURLLoadingConfiguration:(UBImageViewURLLoadingConfiguration *)URLLoadingConfiguration
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingConfiguration, URLLoadingConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UBImageViewURLLoadingConfiguration *)URLLoadingConfiguration
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingConfiguration);
}

- (void)startURLLoading
{
    self.URLImageLoader.delegate = nil;
    
    [self.URLImageLoader cancel];
    
    self.URLImageLoader = [[UBImageLoader alloc] initWithURL:self.URLLoadingConfiguration.URL];
    
    self.URLImageLoader.delegate = self;
    
    [self.URLImageLoader start];
    
    if (self.URLLoadingConfiguration.isPlaceHolderImageEnabled)
    {
        self.image = self.URLLoadingConfiguration.placeHolderImage;
    }
}

- (void)cancelURLLoading
{
    self.URLImageLoader.delegate = nil;
    
    [self.URLImageLoader cancel];
}

@end


@implementation UIImageView (URL_Internal)

- (void)setURLImageLoader:(UBImageLoader *)URLImageLoader
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLImageLoader, URLImageLoader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UBImageLoader *)URLImageLoader
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_URLImageLoader);
}

- (void)imageLoader:(UBImageLoader *)imageLoader didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    if (error)
    {
        if (self.URLLoadingConfiguration.isFailureImageEnabled)
        {
            self.image = self.URLLoadingConfiguration.failureImage;
        }
    }
    else
    {
        self.image = [data length] > 0 ? [UIImage imageWithData:data] : nil;
    }
    
    if (self.URLLoadingConfiguration.completion)
    {
        self.URLLoadingConfiguration.completion(imageLoader.URL, error);
    }
}

- (void)imageLoader:(UBImageLoader *)imageLoader didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    if (self.URLLoadingConfiguration.progressing)
    {
        self.URLLoadingConfiguration.progressing(imageLoader.URL, downloadedSize, expectedSize);
    }
}

@end


@implementation UBImageViewURLLoadingConfiguration

@end


@implementation UIImageView (URLConvenience)

- (void)setImageWithURL:(NSURL *)URL
{
    UBImageViewURLLoadingConfiguration *configuration = [[UBImageViewURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    self.URLLoadingConfiguration = configuration;
    
    [self startURLLoading];
}

- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage completion:(UBImageViewURLLoadingCompletion)completion
{
    UBImageViewURLLoadingConfiguration *configuration = [[UBImageViewURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enablePlaceHolderImage = YES;
    
    configuration.placeHolderImage = placeHolderImage;
    
    configuration.completion = completion;
    
    self.URLLoadingConfiguration = configuration;
    
    [self startURLLoading];
}

@end
