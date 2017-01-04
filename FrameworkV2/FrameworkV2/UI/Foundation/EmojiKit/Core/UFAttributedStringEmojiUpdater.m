//
//  UFAttributedStringEmojiUpdater.m
//  Test
//
//  Created by ww on 15/12/24.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UFAttributedStringEmojiUpdater.h"
#import "UFEmojiUpdater.h"

@interface UFAttributedStringEmojiUpdater ()

@property (nonatomic, copy) NSAttributedString *originalAttributedString;

@property (nonatomic) NSMutableDictionary<NSValue *, UFEmojiUpdater *> *emojiUpdaters;

@property (nonatomic) NSMutableArray *emojiRanges;

@property (nonatomic) CADisplayLink *displayLink;

@property (nonatomic) NSAttributedString *emojiedAttributedString;

@property (nonatomic) BOOL updatable;

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
        
        self.upateImageType = UFEmojiUpdateImageType_ByFrame;
    }
    
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString
{
    if (self = [super init])
    {
        self.originalAttributedString = attributedString;
        
        self.enableAutoUpdate = YES;
        
        self.upateImageType = UFEmojiUpdateImageType_ByFrame;
    }
    
    return self;
}

- (NSAttributedString *)attributedString
{
    return [self.originalAttributedString copy];
}

- (void)startUpdating
{
    NSError *error = nil;
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:self.pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error)
    {
        return;
    }
    
    self.emojiRanges = [[NSMutableArray alloc] init];
    
    self.emojiUpdaters = [[NSMutableDictionary alloc] init];
    
    NSArray *emojiMatches = [regularExpression matchesInString:self.originalAttributedString.string options:0 range:NSMakeRange(0, self.originalAttributedString.length)];
    
    for (NSTextCheckingResult *match in emojiMatches)
    {
        NSString *emojiKey = [self.originalAttributedString.string substringWithRange:match.range];
        
        UFEmoji *emoji = [self.emojiSet emojiForKey:emojiKey];
        
        if (emoji)
        {
            NSValue *rangeValue = [NSValue valueWithRange:match.range];
            
            [self.emojiRanges addObject:rangeValue];
            
            UFEmojiUpdater *updater = nil;
            
            switch (self.upateImageType)
            {
                case UFEmojiUpdateImageType_ByFrame:
                {
                    updater = [[UFEmojiFramingUpdater alloc] initWithEmoji:emoji];
                    
                    break;
                }
                    
                case UFEmojiUpdateImageType_ByImageDuration:
                {
                    updater = [[UFEmojiDurationingUpdater alloc] initWithEmoji:emoji];
                    
                    break;
                }
                    
                default:
                {
                    updater = [[UFEmojiFramingUpdater alloc] initWithEmoji:emoji];
                    
                    break;
                }
            }
            
            if (!self.updatable)
            {
                self.updatable = updater.updatable;
            }
            
            [self.emojiUpdaters setObject:updater forKey:rangeValue];
        }
    }
    
    [self.displayLink invalidate];
    
    self.displayLink = nil;
    
    if (self.updatable && self.isAutoUpdateEnabled && self.emojiUpdaters.count > 0)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        
        self.displayLink.frameInterval = 1;
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    [self update];
}

- (void)stopUpdating
{
    self.delegate = nil;
    
    self.enableAutoUpdate = NO;
    
    self.updatable = NO;
    
    [self.displayLink invalidate];
    
    self.displayLink = nil;
}

- (void)pauseUpdating
{
    self.displayLink.paused = YES;
}

- (void)resumeUpdating
{
    if (self.updatable && self.isAutoUpdateEnabled)
    {
        self.displayLink.paused = NO;
    }
}

- (void)update
{
    NSMutableAttributedString *emojiedAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.originalAttributedString];
    
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    for (NSInteger i = [self.emojiRanges count] - 1; i >= 0; i --)
    {
        NSValue *rangeValue = [self.emojiRanges objectAtIndex:i];
        
        NSRange range = [rangeValue rangeValue];
        
        UFEmojiUpdater *updater = [self.emojiUpdaters objectForKey:rangeValue];
        
        [updater updateWithDuration:self.displayLink.duration * self.displayLink.frameInterval];
        
        UIImage *emojiImage = [updater currentImage];
        
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
        else if (updater.emoji.name)
        {
            [emojiedAttributedString replaceCharactersInRange:range withAttributedString:[[NSAttributedString alloc] initWithString:updater.emoji.name attributes:[emojiedAttributedString attributesAtIndex:range.location effectiveRange:NULL]]];
        }
    }
    
    self.emojiedAttributedString = emojiedAttributedString;
    
    if (self.isAutoUpdateEnabled && self.delegate && [self.delegate respondsToSelector:@selector(attributedStringEmojiUpdater:didUpdateEmojiedAttributedString:)])
    {
        [self.delegate attributedStringEmojiUpdater:self didUpdateEmojiedAttributedString:emojiedAttributedString];
    }
}

- (NSAttributedString *)currentUsableEmojiedAttributedString
{
    return [self.emojiedAttributedString copy];
}

@end
