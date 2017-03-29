//
//  UFAttributedStringEmojiUpdater.m
//  Test
//
//  Created by ww on 06/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "UFAttributedStringEmojiUpdater.h"
#import "UFEmojiImageUpdater.h"

@interface UFAttributedStringEmojiUpdater ()

@property (nonatomic) NSDictionary<NSValue *, UFEmojiImageUpdater *> *imageUpdaters;

@property (nonatomic) CADisplayLink *displayLink;

@property (nonatomic) NSAttributedString *currentAttributedString;

@property (nonatomic) BOOL imageUpdatable;

- (void)update;

@end


@implementation UFAttributedStringEmojiUpdater

- (void)dealloc
{
    [self.displayLink invalidate];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.enableAutoUpdate = YES;
    }
    
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString emojies:(NSDictionary<NSString *,UFEmoji *> *)emojies
{
    if (self = [super init])
    {
        _attributedString = [attributedString copy];
        
        _emojies = emojies;
        
        self.enableAutoUpdate = YES;
    }
    
    return self;
}

- (void)startUpdating
{
    NSMutableDictionary<NSValue *, UFEmojiImageUpdater *> *imageUpdaters = [[NSMutableDictionary alloc] init];
    
    __block BOOL imageUpdatable = NO;
    
    __weak typeof(self) weakSelf = self;
    
    NSArray *allEmojiCodes = [self.emojies allKeys];
    
    [self.attributedString.string enumerateSubstringsInRange:NSMakeRange(0, self.attributedString.string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        if ([allEmojiCodes containsObject:substring])
        {
            UFEmoji *emoji = [weakSelf.emojies objectForKey:substring];
            
            UFCachedEmojiImage *cachedImage = [weakSelf.emojiCache cachedEmojiImageForEmoji:emoji];
            
            if (!cachedImage && emoji)
            {
                UFEmojiImageFrameStream *frameStream = [[UFEmojiImageFrameStream alloc] initWithImage:emoji.image];
                
                cachedImage = [[UFCachedEmojiImage alloc] init];
                
                cachedImage.frameStream = frameStream;
                
                [weakSelf.emojiCache setCachedEmojiImage:cachedImage forEmoji:emoji];
            }
            
            switch (weakSelf.imageUpdateType)
            {
                case UFAttributedStringEmojiImageUpdateByFrame:
                {
                    UFEmojiImageByFrameUpdater *updater = [[UFEmojiImageByFrameUpdater alloc] initWithEmojiImageFrameStream:cachedImage.frameStream];
                    
                    [imageUpdaters setObject:updater forKey:[NSValue valueWithRange:substringRange]];
                    
                    imageUpdatable = imageUpdatable ? YES : [updater imageUpdatable];
                    
                    break;
                }
                    
                case UFAttributedStringEmojiImageUpdateByDuration:
                {
                    UFEmojiImageByDurationUpdater *updater = [[UFEmojiImageByDurationUpdater alloc] initWithEmojiImageFrameStream:cachedImage.frameStream];
                    
                    [imageUpdaters setObject:updater forKey:[NSValue valueWithRange:substringRange]];
                    
                    imageUpdatable = imageUpdatable ? YES : [updater imageUpdatable];
                    
                    break;
                }
                    
                default:
                    break;
            }
        }
    }];
    
    self.imageUpdaters = imageUpdaters;
    
    self.imageUpdatable = imageUpdatable;
    
    [self.displayLink invalidate];
    
    if (self.enableAutoUpdate && self.imageUpdatable)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
        self.displayLink.frameInterval = self.updateFrameInterval;
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    [self update];
}

- (void)stopUpdating
{
    self.imageUpdatable = NO;
    
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
    NSMutableAttributedString *emojiedAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
    
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    NSArray *emojiRanges = [self.imageUpdaters allKeys];
    
    for (NSInteger i = emojiRanges.count - 1; i >= 0; i --)
    {
        NSValue *rangeValue = [emojiRanges objectAtIndex:i];
        
        NSRange range = [rangeValue rangeValue];
        
        UFEmojiImageUpdater *updater = [self.imageUpdaters objectForKey:rangeValue];
        
        [updater advanceByDuration:self.displayLink.duration];
        
        UIImage *emojiImage = [updater currentStaticImage];
        
        if (emojiImage)
        {
            UIFont *font = [[emojiedAttributedString attributesAtIndex:range.location effectiveRange:nil] objectForKey:NSFontAttributeName];
            
            CGFloat textHeight = font.pointSize;
            
            CGFloat imageScale = 1;
            
            if (emojiImage.size.height < textHeight * screenScale - 0.5 || emojiImage.size.height > textHeight * screenScale + 0.5)
            {
                imageScale = textHeight * screenScale / emojiImage.size.height;
            }
            
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            
            textAttachment.image = emojiImage;
            
            textAttachment.bounds = CGRectMake(textAttachment.bounds.origin.x, 0.5 * font.lineHeight + font.descender - 0.5 * textAttachment.image.size.height * imageScale / screenScale, textAttachment.image.size.width * imageScale / screenScale, textAttachment.image.size.height * imageScale / screenScale);
            
            [emojiedAttributedString replaceCharactersInRange:range withAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
        }
    }
    
    self.currentAttributedString = emojiedAttributedString;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(attributedStringEmojiUpdater:didUpdateEmojiedAttributedString:)])
    {
        [self.delegate attributedStringEmojiUpdater:self didUpdateEmojiedAttributedString:emojiedAttributedString];
    }
}

- (NSAttributedString *)currentUsableEmojiedAttributedString
{
    return [self.currentAttributedString copy];
}

@end
