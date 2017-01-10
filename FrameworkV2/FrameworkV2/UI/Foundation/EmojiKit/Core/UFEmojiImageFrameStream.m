//
//  UFEmojiImageFrameStream.m
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFEmojiImageFrameStream.h"

@implementation UFEmojiImageFrameStream

- (instancetype)initWithImageFrames:(NSArray<UFEmojiImageFrame *> *)imageFrames
{
    if (self = [super init])
    {
        _imageFrames = imageFrames;
    }
    
    return self;
}

- (instancetype)initWithImage:(UFEmojiImage *)image
{
    if (self = [super init])
    {
        NSArray *fragments = [image imageFragments];
        
        NSMutableArray<UFEmojiImageFrame *> *frames = [[NSMutableArray alloc] init];
        
        NSTimeInterval timeOffset = 0;
        
        for (NSUInteger i = 0; i < fragments.count; i ++)
        {
            UFEmojiImageFragment *fragment = [fragments objectAtIndex:i];
            
            UFEmojiImageFrame *frame = [[UFEmojiImageFrame alloc] init];
            
            frame.image = fragment.image;
            
            frame.startTime = timeOffset;
            
            frame.endTime = timeOffset + fragment.duration;
            
            timeOffset = frame.endTime;
            
            [frames addObject:frame];
        }
        
        _imageFrames = frames;
    }
    
    return self;
}

- (UIImage *)staticImageAtTimeOffset:(NSTimeInterval)timeOffset
{
    NSTimeInterval duration = ((UFEmojiImageFrame *)[self.imageFrames lastObject]).endTime;
    
    if (duration <= 0)
    {
        return nil;
    }
    
    UIImage *image = nil;
    
    NSTimeInterval offset = timeOffset - ((int)(timeOffset / duration)) * duration;
    
    // 二分查找。self.imageFrames已经按照时间排序
    
    NSUInteger startIndex = 0;
    
    NSUInteger endIndex = self.imageFrames.count - 1;
    
    while (startIndex <= endIndex)
    {
        NSUInteger index = startIndex + (endIndex - startIndex) / 2;
        
        UFEmojiImageFrame *frame = [self.imageFrames objectAtIndex:index];
        
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
    
    return image;
}

- (UIImage *)staticImageAtFrameIndex:(NSUInteger)frameIndex
{
    if (self.imageFrames.count <= 0)
    {
        return nil;
    }
    
    NSUInteger index = frameIndex % self.imageFrames.count;
    
    return ((UFEmojiImageFrame *)[self.imageFrames objectAtIndex:index]).image;
}

@end
