//
//  UIImageView+URL.m
//  FrameworkV1
//
//  Created by ww on 16/5/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UIImageView+URL.h"
#import <objc/runtime.h>

static const char kUIImageViewPropertyKey_URLLoadingConfiguration[] = "URLLoadingConfiguration";

static const char kUIImageViewPropertyKey_URLImageLoader[] = "URLImageLoader";

static const char kUIImageViewPropertyKey_ShouldStartURLLoading[] = "ShouldStartURLLoading";


@implementation UIImageView (URL)

- (void)setURLLoadingConfiguration:(UBViewImageURLLoadingConfiguration *)URLLoadingConfiguration
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingConfiguration, URLLoadingConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UBViewImageURLLoadingConfiguration *)URLLoadingConfiguration
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_URLLoadingConfiguration);
}

- (void)startURLLoading
{
    UBViewImageURLLoadingConfiguration *configuration = self.URLLoadingConfiguration;
    
    if (!configuration)
    {
        return;
    }
    
    UBImageLoader *loader = [[UBImageLoader alloc] initWithURL:configuration.URL];
    
    loader.enableLocalImage = configuration.enableLocalImage;
    
    loader.delegate = self;
    
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLImageLoader, loader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [loader start];
    
    if (configuration.isPlaceHolderImageEnabled)
    {
        self.image = self.URLLoadingConfiguration.placeHolderImage;
    }
}

- (void)startURLLoadingImmediately:(BOOL)immediately
{
    if (immediately)
    {
        [self startURLLoading];
        
        objc_setAssociatedObject(self, kUIImageViewPropertyKey_ShouldStartURLLoading, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else
    {
        BOOL shouldStart = [objc_getAssociatedObject(self, kUIImageViewPropertyKey_ShouldStartURLLoading) boolValue];
        
        if (!shouldStart)
        {
            objc_setAssociatedObject(self, kUIImageViewPropertyKey_ShouldStartURLLoading, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            __weak typeof(self) weakSelf = self;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BOOL shouldStart = [objc_getAssociatedObject(self, kUIImageViewPropertyKey_ShouldStartURLLoading) boolValue];
                
                if (shouldStart)
                {
                    [weakSelf startURLLoading];
                }
                
                objc_setAssociatedObject(weakSelf, kUIImageViewPropertyKey_ShouldStartURLLoading, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            });
        }
    }
    
}

- (void)cancelURLLoading
{
    UBImageLoader *loader = objc_getAssociatedObject(self, kUIImageViewPropertyKey_URLImageLoader);
    
    [loader cancel];
    
    loader.delegate = nil;
    
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_URLImageLoader, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_ShouldStartURLLoading, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)imageLoader:(UBImageLoader *)imageLoader didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    UBViewImageURLLoadingConfiguration *configuration = self.URLLoadingConfiguration;
    
    if (error)
    {
        if (configuration.isFailureImageEnabled)
        {
            self.image = configuration.failureImage;
        }
    }
    else
    {
        self.image = data.length > 0 ? [UIImage imageWithData:data] : nil;
    }
    
    if (configuration.completion)
    {
        configuration.completion(error);
    }
}

- (void)imageLoader:(UBImageLoader *)imageLoader didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    UBViewImageURLLoadingConfiguration *configuration = self.URLLoadingConfiguration;
    
    if (configuration.progressing)
    {
        configuration.progressing(downloadedSize, expectedSize);
    }
}

@end


@implementation UIImageView (URLConvenience)

- (void)setImageWithURL:(NSURL *)URL
{
    UBViewImageURLLoadingConfiguration *configuration = [[UBViewImageURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enableLocalImage = YES;
    
    self.URLLoadingConfiguration = configuration;
    
    [self startURLLoadingImmediately:NO];
}

- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage completion:(UBViewImageURLLoadingCompletion)completion
{
    UBViewImageURLLoadingConfiguration *configuration = [[UBViewImageURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enableLocalImage = YES;
    
    configuration.enablePlaceHolderImage = placeHolderImage ? YES : NO;
    
    configuration.placeHolderImage = placeHolderImage;
    
    configuration.completion = completion;
    
    self.URLLoadingConfiguration = configuration;
    
    [self startURLLoadingImmediately:NO];
}

- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage failureImage:(UIImage *)failureImage completion:(UBViewImageURLLoadingCompletion)completion
{
    UBViewImageURLLoadingConfiguration *configuration = [[UBViewImageURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enableLocalImage = YES;
    
    configuration.enablePlaceHolderImage = placeHolderImage ? YES : NO;
    
    configuration.placeHolderImage = placeHolderImage;
    
    configuration.enableFailureImage = failureImage ? YES : NO;
    
    configuration.failureImage = failureImage;
    
    configuration.completion = completion;
    
    self.URLLoadingConfiguration = configuration;
    
    [self startURLLoadingImmediately:NO];
}

@end
