//
//  UFImageAnimationUpdater.m
//  Test
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFImageAnimationUpdater.h"

@interface UFImageAnimationUpdater ()

@property (nonatomic) CADisplayLink *displayLink;

@property (nonatomic) NSTimeInterval animationDuration;

@property (nonatomic) NSTimeInterval currentFrameTimeOffset;

@property (nonatomic) UIImage *currentFrameImage;

- (void)update;

@end


@implementation UFImageAnimationUpdater

- (void)dealloc
{
    [self.displayLink invalidate];
}

- (instancetype)initWithAnimationFrames:(NSArray<UFImageAnimationFrame *> *)animationFrames
{
    if (self = [super init])
    {
        _animationFrames = animationFrames;
        
        self.animationDuration = ((UFImageAnimationFrame *)[self.animationFrames lastObject]).endTime;
    }
    
    return self;
}

- (void)startUpdating
{
    [self.displayLink invalidate];
    
    self.displayLink = nil;
    
    if (self.animationFrames.count > 0)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
        self.displayLink.frameInterval = self.frameInterval;
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        [self update];
    }
}

- (void)stopUpdating
{
    [self.displayLink invalidate];
    
    self.displayLink = nil;
}

- (void)pauseUpdating
{
    self.displayLink.paused = YES;
}

- (void)resumeUpdating
{
    self.displayLink.paused = NO;
}

- (void)update
{
    self.currentFrameTimeOffset += self.displayLink.duration;
    
    UIImage *image = nil;
    
    NSTimeInterval offset = self.currentFrameTimeOffset - ((int)(self.currentFrameTimeOffset / self.animationDuration)) * self.animationDuration;
    
    // 二分查找。self.animationFrames已经按照时间排序
    
    NSUInteger startIndex = 0;
    
    NSUInteger endIndex = self.animationFrames.count - 1;
    
    while (startIndex <= endIndex)
    {
        NSUInteger index = startIndex + (endIndex - startIndex) / 2;
        
        UFImageAnimationFrame *frame = [self.animationFrames objectAtIndex:index];
        
        if (offset < frame.startTime)
        {
            endIndex = index - 1;
        }
        else if (offset > frame.endTime)
        {
            startIndex = index + 1;
        }
        else
        {
            image = frame.image;
            
            break;
        }
    }
    
    self.currentFrameImage = image;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageAnimationUpdater:didUpdateImage:)])
    {
        [self.delegate imageAnimationUpdater:self didUpdateImage:image];
    }
}

- (UIImage *)currentImage
{
    return self.currentFrameImage;
}

@end
