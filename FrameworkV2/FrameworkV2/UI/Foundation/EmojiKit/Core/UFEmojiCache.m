//
//  UFEmojiCache.m
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFEmojiCache.h"

@interface UFEmojiCache ()

@property (nonatomic) NSMutableDictionary *cachedEmojiImages;

@property (nonatomic) NSMutableArray *emojiCodesAscendingByTime;

@end


@implementation UFEmojiCache

- (instancetype)init
{
    if (self = [super init])
    {
        self.cachedEmojiImages = [[NSMutableDictionary alloc] init];
        
        self.emojiCodesAscendingByTime = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (UFEmojiCache *)sharedInstance
{
    static UFEmojiCache *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[UFEmojiCache alloc] init];
        }
    });
    
    return instance;
}

- (void)setCachedEmojiImage:(UFCachedEmojiImage *)image forEmoji:(UFEmoji *)emoji
{
    if (self.enableAutoCleanCache && self.maxCachedEmojiCount > 0 && self.cachedEmojiImages.count >= self.maxCachedEmojiCount)
    {
        NSUInteger halfCount = 0.5 * self.maxCachedEmojiCount;
        
        NSArray *previousCachedEmojiCodes = [self.emojiCodesAscendingByTime subarrayWithRange:NSMakeRange(0, halfCount)];
        
        if (previousCachedEmojiCodes.count > 0)
        {
            [self.cachedEmojiImages removeObjectsForKeys:previousCachedEmojiCodes];
            
            [self.emojiCodesAscendingByTime removeObjectsInRange:NSMakeRange(0, halfCount)];
        }
    }
    
    if (image && emoji.code)
    {
        [self.cachedEmojiImages setObject:image forKey:emoji.code];
        
        [self.emojiCodesAscendingByTime addObject:emoji.code];
    }
}

- (UFCachedEmojiImage *)cachedEmojiImageForEmoji:(UFEmoji *)emoji
{
    return emoji.code ? [self.cachedEmojiImages objectForKey:emoji.code] : nil;
}

- (void)removeAllCachedEmojiImages
{
    [self.cachedEmojiImages removeAllObjects];
    
    [self.emojiCodesAscendingByTime removeAllObjects];
}

@end


@implementation UFCachedEmojiImage

@end
