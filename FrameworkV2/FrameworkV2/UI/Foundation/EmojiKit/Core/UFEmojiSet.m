//
//  UFEmojiSet.m
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UFEmojiSet.h"

@interface UFEmojiSet ()

@property (nonatomic) NSDictionary<NSString *,UFEmoji *> *emojiDictionary;

@end


@implementation UFEmojiSet

- (instancetype)initWithEmojiDictionary:(NSDictionary<NSString *,UFEmoji *> *)emojiDictionary
{
    if (self = [super init])
    {
        self.emojiDictionary = emojiDictionary;
    }
    
    return self;
}

- (UFEmoji *)emojiForKey:(NSString *)key
{
    return [self.emojiDictionary objectForKey:key];
}

@end


@implementation UFEmojiSet (Cache)

- (void)cleanCache
{
    for (UFEmoji *emoji in [self.emojiDictionary allValues])
    {
        if (emoji.imagePath)
        {
            emoji.image = nil;
        }
    }
}

- (NSUInteger)cacheSize
{
    NSUInteger size = 0;
    
    for (UFEmoji *emoji in [self.emojiDictionary allValues])
    {
        NSUInteger size = 0;
        
        for (UFEmojiImageSource *source in emoji.image.imageSources)
        {
            size += source.image.size.width * source.image.size.height * source.image.scale;
        }
    }
    
    return size;
}

@end
