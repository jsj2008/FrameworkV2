//
//  NSAttributedString+Emoji.h
//  FrameworkV2
//
//  Created by ww on 03/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFEmojiSet.h"

/*********************************************************
 
    @category
        NSAttributedString (Emoji)
 
    @abstract
        NSAttributedString的表情扩展
 
 *********************************************************/

@interface NSAttributedString (Emoji)

/*!
 * @brief 使用首帧图片渲染的表情AttributedString
 * @param pattern 表情匹配的正则表达式
 * @param emojiSet 表情集
 * @result AttributedString
 */
- (NSAttributedString *)firstImageEmojiedAttributedStringWithPattern:(NSString *)pattern emojiSet:(UFEmojiSet *)emojiSet;

@end
