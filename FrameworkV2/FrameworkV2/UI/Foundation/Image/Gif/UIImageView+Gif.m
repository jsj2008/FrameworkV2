//
//  UIImageView+Gif.m
//  Test
//
//  Created by ww on 16/3/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UIImageView+Gif.h"
#import "UFImageViewGifUpdater.h"
#import <objc/runtime.h>

static const char kUIImageViewPropertyKey_GifData[] = "gifData";

static const char kUIImageViewPropertyKey_GifUpdateType[] = "gifUpdateType";

static const char kUIImageViewPropertyKey_GifUpdater[] = "gifUpdater";


@implementation UIImageView (Gif)

- (void)setGifData:(NSData *)gifData
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_GifData, gifData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)gifData
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifData);
}

- (void)setGifUpdateType:(UFGifImageUpdateType)gifUpdateType
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_GifUpdateType, [NSNumber numberWithUnsignedInteger:gifUpdateType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFGifImageUpdateType)gifUpdateType
{
    return [objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifUpdateType) unsignedIntegerValue];
}

- (void)setGifUpdater:(UFImageViewGifUpdater *)gifUpdater
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater, gifUpdater, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UFImageViewGifUpdater *)gifUpdater
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater);
}

- (void)startGifAnimating
{
    UFImageViewGifUpdater *updater = objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater);
    
    [updater stopUpdating];
    
    switch (self.gifUpdateType)
    {
        case UFGifImageUpdateType_ByFrame:
        {
            updater = [[UFImageViewFramingGifUpdater alloc] initWithGifData:self.gifData];
            
            updater.imageView = self;
            
            break;
        }
        case UFGifImageUpdateType_ByImageDuration:
        {
            updater = [[UFImageViewDurationingGifUpdater alloc] initWithGifData:self.gifData];
            
            updater.imageView = self;
            
            break;
        }
            
        default:
        {
            updater = [[UFImageViewFramingGifUpdater alloc] initWithGifData:self.gifData];
            
            updater.imageView = self;
            
            break;
        }
    }
    
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater, updater, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [updater startUpdating];
}

- (void)stopGifAnimating
{
    UFImageViewGifUpdater *updater = objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater);
    
    [updater stopUpdating];
}

- (void)pauseGifAnimating
{
    UFImageViewGifUpdater *updater = objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater);
    
    [updater pauseUpdating];
}

- (void)resumeGifAnimating
{
    UFImageViewGifUpdater *updater = objc_getAssociatedObject(self, kUIImageViewPropertyKey_GifUpdater);
    
    [updater resumeUpdating];
}

@end
