//
//  UFEmojiImage.m
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFEmojiImage.h"
#import <ImageIO/ImageIO.h>

@implementation UFEmojiImage

- (NSArray<UFEmojiImageFragment *> *)imageFragments
{
    return nil;
}

@end


@implementation UFEmojiStaticUIImage

- (NSArray<UFEmojiImageFragment *> *)imageFragments
{
    if (!self.image)
    {
        return nil;
    }
    
    UFEmojiImageFragment *fragment = [[UFEmojiImageFragment alloc] init];
    
    fragment.image = self.image;
    
    fragment.duration = self.duration;
    
    return [NSArray arrayWithObject:fragment];
}

@end


@implementation UFEmojiStaticFileImage

- (NSArray<UFEmojiImageFragment *> *)imageFragments
{
    if (self.imageFilePath.length == 0)
    {
        return nil;
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:self.imageFilePath];
    
    if (!image)
    {
        return nil;
    }
    
    UFEmojiImageFragment *fragment = [[UFEmojiImageFragment alloc] init];
    
    fragment.image = image;
    
    fragment.duration = self.duration;
    
    return [NSArray arrayWithObject:fragment];
}

@end


@implementation UFEmojiGIFImage

- (NSArray<UFEmojiImageFragment *> *)imageFragments
{
    if (self.GIFPath.length == 0)
    {
        return nil;
    }
    
    NSMutableArray<UFEmojiImageFragment *> *fragments = [[NSMutableArray alloc] init];
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:self.GIFPath], NULL);
    
    size_t sourceCount = CGImageSourceGetCount(gifSource);
    
    for (size_t i = 0; i < sourceCount; i ++)
    {
        UFEmojiImageFragment *fragment = [[UFEmojiImageFragment alloc] init];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        
        fragment.image = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        
        NSDictionary *gifProperties = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        NSNumber *delayTime = [gifProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
        
        if (!delayTime)
        {
            delayTime = [gifProperties objectForKey:(NSString *)kCGImagePropertyGIFDelayTime];
        }
        
        fragment.duration = [delayTime doubleValue];
        
        if (fragment.image)
        {
            [fragments addObject:fragment];
        }
    }
    
    return fragments.count > 0 ? fragments : nil;
}

@end


@implementation UFEmojiGroupedImage

- (NSArray<UFEmojiImageFragment *> *)imageFragments
{
    if (self.groupedImages.count == 0)
    {
        return nil;
    }
    
    NSMutableArray<UFEmojiImageFragment *> *groupedFragments = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < self.groupedImages.count; i ++)
    {
        UFEmojiImage *image = [self.groupedImages objectAtIndex:i];
        
        NSArray *fragments = [image imageFragments];
        
        if (fragments.count > 0)
        {
            [groupedFragments addObjectsFromArray:fragments];
        }
    }
    
    return groupedFragments.count > 0 ? groupedFragments : nil;
}

@end


@implementation UFEmojiImageFragment

@end
