//
//  UFEmojiImageSequenceUpdater.m
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFEmojiImageUpdater.h"
#import "UFEmojiImageFrameStream.h"

@implementation UFEmojiImageUpdater

- (instancetype)initWithEmojiImageFrameStream:(UFEmojiImageFrameStream *)emojiImageFrameStream
{
    if (self = [super init])
    {
        _imageFrameStream = emojiImageFrameStream;
    }
    
    return self;
}

- (BOOL)imageUpdatable
{
    return self.imageFrameStream.imageFrames.count > 1;
}

- (void)advanceByDuration:(NSTimeInterval)duration
{
    
}

- (UIImage *)currentStaticImage
{
    return nil;
}

@end


@interface UFEmojiImageByDurationUpdater ()

@property (nonatomic) NSTimeInterval duration;

@end


@implementation UFEmojiImageByDurationUpdater

- (void)advanceByDuration:(NSTimeInterval)duration
{
    self.duration += duration;
}

- (UIImage *)currentStaticImage
{
    return [self.imageFrameStream staticImageAtTimeOffset:self.duration];
}

@end


@interface UFEmojiImageByFrameUpdater ()

@property (nonatomic) NSUInteger frameIndex;

@end


@implementation UFEmojiImageByFrameUpdater

- (void)advanceByDuration:(NSTimeInterval)duration
{
    if (duration > 0)
    {
        self.frameIndex ++;
    }
}

- (UIImage *)currentStaticImage
{
    return [self.imageFrameStream staticImageAtFrameIndex:self.frameIndex];
}

@end
