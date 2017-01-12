//
//  UIImageView+AnimationImage.m
//  Test
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UIImageView+AnimationImage.h"
#import <objc/runtime.h>

static const char kUIImageViewPropertyKey_ImageAnimationFrames[] = "imageAnimationFrames";

static const char kUIImageViewPropertyKey_ImageAnimationFrameInterval[] = "imageAnimationFrameInterval";

static const char kUIImageViewPropertyKey_ImageAnimationUpdater[] = "ImageAnimationUpdater";


@implementation UIImageView (AnimationImage)

- (void)setImageAnimationFrames:(NSArray<UFImageAnimationFrame *> *)imageAnimationFrames
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationFrames, imageAnimationFrames, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<UFImageAnimationFrame *> *)imageAnimationFrames
{
    return objc_getAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationFrames);
}

- (void)setImageAnimationFrameInterval:(NSUInteger)imageAnimationFrameInterval
{
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationFrameInterval, [NSNumber numberWithUnsignedInteger:imageAnimationFrameInterval], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)imageAnimationFrameInterval
{
    NSNumber *frameIntervalNumber = objc_getAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationFrameInterval);
    
    return [frameIntervalNumber unsignedIntegerValue];
}

- (void)startImageAnimating
{
    NSArray<UFImageAnimationFrame *> *frames = self.imageAnimationFrames;
    
    if (frames.count <= 0)
    {
        return;
    }
    
    UFImageAnimationUpdater *updater = [[UFImageAnimationUpdater alloc] initWithAnimationFrames:frames];
    
    updater.frameInterval = self.imageAnimationFrameInterval;
    
    updater.delegate = self;
    
    objc_setAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationUpdater, updater, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [updater startUpdating];
    
    self.image = [updater currentImage];
}

- (void)stopImageAnimating
{
    UFImageAnimationUpdater *updater = objc_getAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationUpdater);
    
    [updater stopUpdating];
}

- (void)pauseImageAnimating
{
    UFImageAnimationUpdater *updater = objc_getAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationUpdater);
    
    [updater pauseUpdating];
}

- (void)resumeImageAnimating
{
    UFImageAnimationUpdater *updater = objc_getAssociatedObject(self, kUIImageViewPropertyKey_ImageAnimationUpdater);
    
    [updater resumeUpdating];
}

- (void)imageAnimationUpdater:(UFImageAnimationUpdater *)updater didUpdateImage:(UIImage *)image
{
    self.image = image;
}

@end
