//
//  UFEmojiUpdater.m
//  FrameworkV2
//
//  Created by ww on 03/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFEmojiUpdater.h"

@interface UFEmojiUpdater ()

@property (nonatomic) UIImage *image;

@end


@implementation UFEmojiUpdater

- (instancetype)initWithEmoji:(UFEmoji *)emoji
{
    if (self = [super init])
    {
        _emoji = [emoji copy];
        
        _updatable = emoji.image.updatable;
    }
    
    return self;
}

- (UIImage *)currentImage
{
    return self.image;
}

- (void)updateWithDuration:(NSTimeInterval)duration
{
    
}

@end


@interface UFEmojiFramingUpdater ()

@property (nonatomic) NSUInteger sourceIndex;

@end


@implementation UFEmojiFramingUpdater

- (void)updateWithDuration:(NSTimeInterval)duration
{
    if (self.updatable && self.emoji.image.imageSources.count > 0)
    {
        if (self.sourceIndex > self.emoji.image.imageSources.count - 1)
        {
            self.sourceIndex = 0;
        }
        
        self.image = ((UFEmojiImageSource *)[self.emoji.image.imageSources objectAtIndex:self.sourceIndex]).image;
        
        self.sourceIndex ++;
    }
}

@end


@interface UFEmojiDurationingUpdater ()

@property (nonatomic) NSTimeInterval elapsedDuration;

@property (nonatomic) NSMutableArray *sourceDurations;

@end


@implementation UFEmojiDurationingUpdater

- (instancetype)initWithEmoji:(UFEmoji *)emoji
{
    if (self = [super initWithEmoji:emoji])
    {
        self.elapsedDuration = 0;
        
        self.sourceDurations = [[NSMutableArray alloc] init];
        
        NSTimeInterval duration = 0;
        
        if (!emoji.image && emoji.imagePath)
        {
            emoji.image = [emoji imageWithPath:emoji.imagePath];
        }
        
        for (UFEmojiImageSource *source in emoji.image.imageSources)
        {
            duration += source.duration;
            
            [self.sourceDurations addObject:[NSNumber numberWithDouble:duration]];
        }
    }
    
    return self;
}

- (void)updateWithDuration:(NSTimeInterval)duration
{
    UIImage *image = nil;
    
    if (self.updatable && self.sourceDurations.count > 0)
    {
        self.elapsedDuration += duration;
        
        NSTimeInterval loopDuration = [[self.sourceDurations lastObject] doubleValue];
        
        if (loopDuration > 0)
        {
            NSTimeInterval durationInLoop = self.elapsedDuration - ((NSInteger)(self.elapsedDuration / loopDuration)) * loopDuration;
            
            NSInteger index = [self.sourceDurations indexOfObject:[NSNumber numberWithDouble:durationInLoop] inSortedRange:NSMakeRange(0, [self.sourceDurations count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                return [obj1 compare:obj2];
            }];
            
            if (index < 0)
            {
                index = 0;
            }
            else if (index > [self.sourceDurations count] - 1)
            {
                index = [self.sourceDurations count] - 1;
            }
            
            image = ((UFEmojiImageSource *)[self.emoji.image.imageSources objectAtIndex:index]).image;
        }
    }
    
    self.image = image;
}

@end
