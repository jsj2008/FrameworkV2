//
//  UIButton+URL.m
//  FrameworkV2
//
//  Created by ww on 20/12/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UIButton+URL.h"
#import <objc/runtime.h>

static const char kUIButtonPropertyKey_URLLoadingConfigurations[] = "URLLoadingConfigurations";

static const char kUIButtonPropertyKey_URLImageLoaders[] = "URLImageLoaders";


@implementation UIButton (URL)

- (void)setURLLoadingConfigurations:(NSDictionary<NSNumber *,UBViewImageURLLoadingConfiguration *> *)URLLoadingConfigurations
{
    objc_setAssociatedObject(self, kUIButtonPropertyKey_URLLoadingConfigurations, URLLoadingConfigurations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary<NSNumber *,UBViewImageURLLoadingConfiguration *> *)URLLoadingConfigurations
{
    return objc_getAssociatedObject(self, kUIButtonPropertyKey_URLLoadingConfigurations);
}

- (void)startURLLoadingForState:(UIControlState)state
{
    NSNumber *stateNumber = [NSNumber numberWithUnsignedInteger:state];
    
    UBViewImageURLLoadingConfiguration *configuration = [self.URLLoadingConfigurations objectForKey:stateNumber];
    
    UBImageLoader *loader = [[UBImageLoader alloc] initWithURL:configuration.URL];
    
    loader.enableLocalImage = configuration.enableLocalImage;
    
    loader.delegate = self;
    
    NSMutableDictionary<NSNumber *, UBImageLoader *> *loaders = objc_getAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders);
    
    if (!loaders)
    {
        loaders = [[NSMutableDictionary alloc] init];
        
        objc_setAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders, loaders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [loaders setObject:loader forKey:stateNumber];
    
    [loader start];
    
    if (configuration.isPlaceHolderImageEnabled)
    {
        [self setImage:configuration.placeHolderImage forState:state];
    }
}

- (void)startAllURLLoading
{
    NSMutableDictionary<NSNumber *, UBImageLoader *> *loaders = objc_getAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders);
    
    [loaders removeAllObjects];
    
    if (!loaders)
    {
        loaders = [[NSMutableDictionary alloc] init];
        
        objc_setAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders, loaders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    for (NSNumber *stateNumber in [self.URLLoadingConfigurations allKeys])
    {
        UBViewImageURLLoadingConfiguration *configuration = [self.URLLoadingConfigurations objectForKey:stateNumber];
        
        UBImageLoader *loader = [[UBImageLoader alloc] initWithURL:configuration.URL];
        
        loader.enableLocalImage = configuration.enableLocalImage;
        
        loader.delegate = self;
        
        [loaders setObject:loader forKey:stateNumber];
        
        [loader start];
        
        if (configuration.isPlaceHolderImageEnabled)
        {
            [self setImage:configuration.placeHolderImage forState:[stateNumber unsignedIntegerValue]];
        }
    }
}

- (void)cancelURLLoadingForState:(UIControlState)state
{
    NSMutableDictionary<NSNumber *, UBImageLoader *> *loaders = objc_getAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders);
    
    [loaders removeObjectForKey:[NSNumber numberWithUnsignedInteger:state]];
}

- (void)cancelAllURLLoading
{
    NSMutableDictionary<NSNumber *, UBImageLoader *> *loaders = objc_getAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders);
    
    [loaders removeAllObjects];
}

- (void)imageLoader:(UBImageLoader *)imageLoader didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    NSMutableDictionary<NSNumber *, UBImageLoader *> *loaders = objc_getAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders);
    
    NSNumber *stateNumber = [[loaders allKeysForObject:imageLoader] firstObject];
    
    if (!stateNumber)
    {
        return;
    }
    
    UBViewImageURLLoadingConfiguration *configuration = [self.URLLoadingConfigurations objectForKey:stateNumber];
    
    if (error)
    {
        if (configuration.isFailureImageEnabled)
        {
            [self setImage:configuration.failureImage forState:[stateNumber unsignedIntegerValue]];
        }
    }
    else
    {
        [self setImage:data.length > 0 ? [UIImage imageWithData:data] : nil forState:[stateNumber unsignedIntegerValue]];
    }
    
    if (configuration.completion)
    {
        configuration.completion(error);
    }
}

- (void)imageLoader:(UBImageLoader *)imageLoader didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    NSMutableDictionary<NSNumber *, UBImageLoader *> *loaders = objc_getAssociatedObject(self, kUIButtonPropertyKey_URLImageLoaders);
    
    NSNumber *stateNumber = [[loaders allKeysForObject:imageLoader] firstObject];
    
    if (!stateNumber)
    {
        return;
    }
    
    UBViewImageURLLoadingConfiguration *configuration = [self.URLLoadingConfigurations objectForKey:stateNumber];
    
    if (configuration.progressing)
    {
        configuration.progressing(downloadedSize, expectedSize);
    }
}

@end


@implementation UIButton (URLConvenience)

- (void)setImageWithURL:(NSURL *)URL forState:(UIControlState)state
{
    UBViewImageURLLoadingConfiguration *configuration = [[UBViewImageURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enableLocalImage = YES;
    
    NSMutableDictionary *configurations = [[NSMutableDictionary alloc] init];
    
    if (self.URLLoadingConfigurations.count > 0)
    {
        [configurations addEntriesFromDictionary:self.URLLoadingConfigurations];
    }
    
    [configurations setObject:configuration forKey:[NSNumber numberWithUnsignedInteger:state]];
    
    self.URLLoadingConfigurations = configurations;
    
    [self startURLLoadingForState:state];
}

- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage completion:(UBViewImageURLLoadingCompletion)completion forState:(UIControlState)state
{
    UBViewImageURLLoadingConfiguration *configuration = [[UBViewImageURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enableLocalImage = YES;
    
    configuration.enablePlaceHolderImage = placeHolderImage ? YES : NO;
    
    configuration.placeHolderImage = placeHolderImage;
    
    configuration.completion = completion;
    
    NSMutableDictionary *configurations = [[NSMutableDictionary alloc] init];
    
    if (self.URLLoadingConfigurations.count > 0)
    {
        [configurations addEntriesFromDictionary:self.URLLoadingConfigurations];
    }
    
    [configurations setObject:configuration forKey:[NSNumber numberWithUnsignedInteger:state]];
    
    self.URLLoadingConfigurations = configurations;
    
    [self startURLLoadingForState:state];
}

- (void)setImageWithURL:(NSURL *)URL placeHolderImage:(UIImage *)placeHolderImage failureImage:(UIImage *)failureImage completion:(UBViewImageURLLoadingCompletion)completion forState:(UIControlState)state
{
    UBViewImageURLLoadingConfiguration *configuration = [[UBViewImageURLLoadingConfiguration alloc] init];
    
    configuration.URL = URL;
    
    configuration.enableLocalImage = YES;
    
    configuration.enablePlaceHolderImage = placeHolderImage ? YES : NO;
    
    configuration.placeHolderImage = placeHolderImage;
    
    configuration.enableFailureImage = failureImage ? YES : NO;
    
    configuration.failureImage = failureImage;
    
    configuration.completion = completion;
    
    NSMutableDictionary *configurations = [[NSMutableDictionary alloc] init];
    
    if (self.URLLoadingConfigurations.count > 0)
    {
        [configurations addEntriesFromDictionary:self.URLLoadingConfigurations];
    }
    
    [configurations setObject:configuration forKey:[NSNumber numberWithUnsignedInteger:state]];
    
    self.URLLoadingConfigurations = configurations;
    
    [self startURLLoadingForState:state];
}

@end
