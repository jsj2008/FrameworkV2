//
//  NSAttributedString+Emoji.m
//  FrameworkV2
//
//  Created by ww on 03/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "NSAttributedString+Emoji.h"

@implementation NSAttributedString (Emoji)

- (NSAttributedString *)firstImageEmojiedAttributedStringWithPattern:(NSString *)pattern emojiSet:(UFEmojiSet *)emojiSet
{
    NSError *error = nil;
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error)
    {
        return nil;
    }
    
    NSArray *emojiMatches = [regularExpression matchesInString:self.string options:0 range:NSMakeRange(0, self.length)];
    
    if (emojiMatches.count == 0)
    {
        return [[NSAttributedString alloc] initWithAttributedString:self];
    }
    
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    NSMutableAttributedString *emojiedAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    
    for (NSUInteger i = emojiMatches.count - 1; ; i --)
    {
        NSTextCheckingResult *match = [emojiMatches objectAtIndex:i];
        
        NSString *emojiKey = [self.string substringWithRange:match.range];
        
        UFEmoji *emoji = [emojiSet emojiForKey:emojiKey];
        
        if (emoji)
        {
            if (!emoji.image && emoji.imagePath)
            {
                emoji.image = [emoji imageWithPath:emoji.imagePath];
            }
            
            UIImage *emojiImage = ((UFEmojiImageSource *)[emoji.image.imageSources firstObject]).image;
            
            if (emojiImage)
            {
                UIFont *font = [[self attributesAtIndex:match.range.location effectiveRange:nil] objectForKey:NSFontAttributeName];
                
                CGFloat textHeight = font.pointSize;
                
                CGFloat imageScale = 1;
                
                if (emojiImage.size.height < textHeight * screenScale - 0.5 || emojiImage.size.height > textHeight * screenScale + 0.5)
                {
                    imageScale = textHeight * screenScale / emojiImage.size.height;
                }
                
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                
                textAttachment.image = emojiImage;
                
                textAttachment.bounds = CGRectMake(textAttachment.bounds.origin.x, 0.5 * font.lineHeight + font.descender - 0.5 * textAttachment.image.size.height * imageScale / screenScale, textAttachment.image.size.width * imageScale / screenScale, textAttachment.image.size.height * imageScale / screenScale);
                
                [emojiedAttributedString replaceCharactersInRange:match.range withAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
            }
        }
    }
    
    return emojiedAttributedString;
}

@end
