//
//  UFEmoji.m
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UFEmoji.h"

@implementation UFEmoji

- (id)copyWithZone:(NSZone *)zone
{
    UFEmoji *one = [[UFEmoji alloc] init];
    
    one.name = self.name;
    
    one.image = self.image;
    
    one.imagePath = self.imagePath;
    
    return one;
}

@end


@implementation UFEmoji (Path)

- (UFEmojiImage *)imageWithPath:(NSString *)path
{
    UFEmojiImage *image = nil;
    
    NSString *pathExtension = [path.pathExtension lowercaseString];
    
    if ([pathExtension isEqualToString:@"gif"])
    {
        image = [UFEmojiImage emojiImageWithGifPath:path];
    }
    else if ([pathExtension isEqualToString:@"png"] || [pathExtension isEqualToString:@"jpg"] || [pathExtension isEqualToString:@"jpeg"])
    {
        image = [UFEmojiImage emojiImageWithPath:path];
    }
    
    return image;
}

@end


@implementation UFEmoji (Cache)

- (void)cleanCache
{
    if (self.imagePath)
    {
        self.image = nil;
    }
}

- (NSUInteger)cacheSize
{
    NSUInteger size = 0;
    
    if (self.image && self.imagePath)
    {
        for (UFEmojiImageSource *source in self.image.imageSources)
        {
            size += source.image.size.width * source.image.size.height * source.image.scale;
        }
    }
    
    return size;
}

@end
