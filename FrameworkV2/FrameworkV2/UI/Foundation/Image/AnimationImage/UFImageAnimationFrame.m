//
//  UFImageAnimationFrame.m
//  Test
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFImageAnimationFrame.h"
#import <ImageIO/ImageIO.h>

@implementation UFImageAnimationFrame

@end


@implementation UFImageAnimationFrame (Creation)

+ (NSArray<UFImageAnimationFrame *> *)animationFramesWithGIFData:(NSData *)GIFData
{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    NSTimeInterval timeOffset = 0;
    
    CGImageSourceRef GIFSource = CGImageSourceCreateWithData((CFDataRef)GIFData, NULL);
    
    size_t sourceCount = CGImageSourceGetCount(GIFSource);
    
    for (size_t i = 0; i < sourceCount; i ++)
    {
        CGImageRef image = CGImageSourceCreateImageAtIndex(GIFSource, i, NULL);
        
        if (!image)
        {
            continue;
        }
        
        UFImageAnimationFrame *frame = [[UFImageAnimationFrame alloc] init];
        
        frame.image = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(GIFSource, i, NULL));
        
        NSDictionary *GIFProperties = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        NSNumber *delayTime = [GIFProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
        
        if (!delayTime)
        {
            delayTime = [GIFProperties objectForKey:(NSString *)kCGImagePropertyGIFDelayTime];
        }
        
        frame.startTime = timeOffset;
        
        frame.endTime = timeOffset + [delayTime doubleValue];
        
        timeOffset = frame.endTime;
        
        [frames addObject:frame];
    }
    
    return frames.count > 0 ? frames : nil;
}

@end
