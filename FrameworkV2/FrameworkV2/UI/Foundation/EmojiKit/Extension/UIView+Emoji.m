//
//  UIView+Emoji.m
//  Test
//
//  Created by ww on 15/12/23.
//  Copyright © 2015年 ww. All rights reserved.
//

#import "UIView+Emoji.h"
#import "UFAttributedStringEmojiUpdater.h"
#import <objc/runtime.h>

@implementation UFViewEmojiConfiguration

- (instancetype)init
{
    if (self = [super init])
    {
        self.enableAutoUpdate = YES;
    }
    
    return self;
}

@end


static const char kUIViewPropertyKey_EmojiConfiguration[] = "emojiConfiguration";

static const char kUIViewPropertyKey_EmojiUpdaters[] = "emojiUpdaters";


@implementation UIView (Emoji)

- (UFViewEmojiConfiguration *)emojiConfiguration
{
    return objc_getAssociatedObject(self, kUIViewPropertyKey_EmojiConfiguration);
}

- (void)setEmojiConfiguration:(UFViewEmojiConfiguration *)emojiConfiguration
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_EmojiConfiguration, emojiConfiguration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)emojiUpdaters
{
    return objc_getAssociatedObject(self, kUIViewPropertyKey_EmojiUpdaters);
}

- (void)setEmojiUpdaters:(NSMutableDictionary *)emojiUpdaters
{
    objc_setAssociatedObject(self, kUIViewPropertyKey_EmojiUpdaters, emojiUpdaters, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)attributedStringEmojiUpdater:(UFAttributedStringEmojiUpdater *)updater didUpdateEmojiedAttributedString:(NSAttributedString *)emojiedAttributedString
{
    ;
}

@end


@implementation UILabel (Emoji)

- (void)showEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[UFAttributedStringEmojiUpdater alloc] initWithAttributedString:self.attributedText emojies:self.emojiConfiguration.emojiSet];
    
    emojiUpdater.emojiCache = self.emojiConfiguration.emojiCache;
    
    emojiUpdater.enableAutoUpdate = self.emojiConfiguration.enableAutoUpdate;
    
    emojiUpdater.updateFrameInterval = self.emojiConfiguration.updateFrameInterval;
    
    emojiUpdater.imageUpdateType = (int)self.emojiConfiguration.imageUpdateType;
    
    emojiUpdater.delegate = self;
    
    [self setEmojiUpdaters:[NSMutableDictionary dictionaryWithObject:emojiUpdater forKey:@"default"]];
    
    [emojiUpdater startUpdating];
}

- (void)closeEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    self.attributedText = emojiUpdater.attributedString;
    
    [emojiUpdater stopUpdating];
    
    [self setEmojiUpdaters:nil];
}

- (void)hideEmoji:(BOOL)hide
{
    if (hide)
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
        
        self.attributedText = emojiUpdater.attributedString;
        
        emojiUpdater.delegate = nil;
    }
    else
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
        
        emojiUpdater.delegate = self;
    }
}

- (void)pauseEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    emojiUpdater.delegate = nil;
    
    [emojiUpdater pauseUpdating];
}

- (void)resumeEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    emojiUpdater.delegate = self;
    
    [emojiUpdater resumeUpdating];
}

- (void)attributedStringEmojiUpdater:(UFAttributedStringEmojiUpdater *)updater didUpdateEmojiedAttributedString:(NSAttributedString *)emojiedAttributedString
{
    self.attributedText = emojiedAttributedString;
}

@end


@implementation UIButton (Emoji)

- (void)showEmojiForState:(UIControlState)state
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[UFAttributedStringEmojiUpdater alloc] initWithAttributedString:[self attributedTitleForState:state] emojies:self.emojiConfiguration.emojiSet];
    
    emojiUpdater.emojiCache = self.emojiConfiguration.emojiCache;
    
    emojiUpdater.enableAutoUpdate = self.emojiConfiguration.enableAutoUpdate;
    
    emojiUpdater.updateFrameInterval = self.emojiConfiguration.updateFrameInterval;
    
    emojiUpdater.imageUpdateType = (int)self.emojiConfiguration.imageUpdateType;
    
    emojiUpdater.delegate = self;
    
    emojiUpdater.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:state] forKey:@"state"];
    
    [self setEmojiUpdaters:[NSMutableDictionary dictionaryWithObject:emojiUpdater forKey:[NSNumber numberWithUnsignedInteger:state]]];
    
    [emojiUpdater startUpdating];
}

- (void)closeEmojiForState:(UIControlState)state
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:[NSNumber numberWithUnsignedInteger:state]];
    
    [self setAttributedTitle:emojiUpdater.attributedString forState:state];
    
    [emojiUpdater stopUpdating];
    
    [[self emojiUpdaters] removeObjectForKey:[NSNumber numberWithUnsignedInteger:state]];
}

- (void)hideEmoji:(BOOL)hide forState:(UIControlState)state
{
    if (hide)
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:[NSNumber numberWithUnsignedInteger:state]];
        
        [self setAttributedTitle:emojiUpdater.attributedString forState:state];
        
        emojiUpdater.delegate = nil;
    }
    else
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:[NSNumber numberWithUnsignedInteger:state]];
        
        emojiUpdater.delegate = self;
    }
}

- (void)pauseEmojiForState:(UIControlState)state
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:[NSNumber numberWithUnsignedInteger:state]];
    
    emojiUpdater.delegate = nil;
    
    [emojiUpdater pauseUpdating];
}

- (void)resumeEmojiForState:(UIControlState)state
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:[NSNumber numberWithUnsignedInteger:state]];
    
    emojiUpdater.delegate = self;
    
    [emojiUpdater resumeUpdating];
}

- (void)attributedStringEmojiUpdater:(UFAttributedStringEmojiUpdater *)updater didUpdateEmojiedAttributedString:(NSAttributedString *)emojiedAttributedString
{
    [self setAttributedTitle:emojiedAttributedString forState:[[updater.userInfo objectForKey:@"state"] unsignedIntegerValue]];
}

@end


@implementation UITextField (Emoji)

- (void)showEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[UFAttributedStringEmojiUpdater alloc] initWithAttributedString:self.attributedText emojies:self.emojiConfiguration.emojiSet];
    
    emojiUpdater.emojiCache = self.emojiConfiguration.emojiCache;
    
    emojiUpdater.enableAutoUpdate = self.emojiConfiguration.enableAutoUpdate;
    
    emojiUpdater.updateFrameInterval = self.emojiConfiguration.updateFrameInterval;
    
    emojiUpdater.imageUpdateType = (int)self.emojiConfiguration.imageUpdateType;
    
    emojiUpdater.delegate = self;
    
    [self setEmojiUpdaters:[NSMutableDictionary dictionaryWithObject:emojiUpdater forKey:@"default"]];
    
    [emojiUpdater startUpdating];
}

- (void)closeEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    self.attributedText = emojiUpdater.attributedString;
    
    [emojiUpdater stopUpdating];
    
    [self setEmojiUpdaters:nil];
}

- (void)hideEmoji:(BOOL)hide
{
    if (hide)
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
        
        self.attributedText = emojiUpdater.attributedString;
        
        emojiUpdater.delegate = nil;
    }
    else
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
        
        emojiUpdater.delegate = self;
    }
}

- (void)pauseEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    emojiUpdater.delegate = nil;
    
    [emojiUpdater pauseUpdating];
}

- (void)resumeEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    emojiUpdater.delegate = self;
    
    [emojiUpdater resumeUpdating];
}

- (void)attributedStringEmojiUpdater:(UFAttributedStringEmojiUpdater *)updater didUpdateEmojiedAttributedString:(NSAttributedString *)emojiedAttributedString
{
    self.attributedText = emojiedAttributedString;
}

@end


@implementation UITextView (Emoji)

- (void)showEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[UFAttributedStringEmojiUpdater alloc] initWithAttributedString:self.attributedText emojies:self.emojiConfiguration.emojiSet];
    
    emojiUpdater.emojiCache = self.emojiConfiguration.emojiCache;
    
    emojiUpdater.enableAutoUpdate = self.emojiConfiguration.enableAutoUpdate;
    
    emojiUpdater.updateFrameInterval = self.emojiConfiguration.updateFrameInterval;
    
    emojiUpdater.imageUpdateType = (int)self.emojiConfiguration.imageUpdateType;
    
    emojiUpdater.delegate = self;
    
    [self setEmojiUpdaters:[NSMutableDictionary dictionaryWithObject:emojiUpdater forKey:@"default"]];
    
    [emojiUpdater startUpdating];
}

- (void)closeEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    self.attributedText = emojiUpdater.attributedString;
    
    [emojiUpdater stopUpdating];
    
    [self setEmojiUpdaters:nil];
}

- (void)hideEmoji:(BOOL)hide
{
    if (hide)
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
        
        self.attributedText = emojiUpdater.attributedString;
        
        emojiUpdater.delegate = nil;
    }
    else
    {
        UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
        
        emojiUpdater.delegate = self;
    }
}

- (void)pauseEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    emojiUpdater.delegate = nil;
    
    [emojiUpdater pauseUpdating];
}

- (void)resumeEmoji
{
    UFAttributedStringEmojiUpdater *emojiUpdater = [[self emojiUpdaters] objectForKey:@"default"];
    
    emojiUpdater.delegate = self;
    
    [emojiUpdater resumeUpdating];
}

- (void)attributedStringEmojiUpdater:(UFAttributedStringEmojiUpdater *)updater didUpdateEmojiedAttributedString:(NSAttributedString *)emojiedAttributedString
{
    self.attributedText = emojiedAttributedString;
}

@end
