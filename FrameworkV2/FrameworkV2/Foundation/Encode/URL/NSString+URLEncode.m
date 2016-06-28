//
//  NSString+URLEncode.m
//  Test1
//
//  Created by ww on 16/4/15.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

- (NSString *)stringByAddingURLEncoding
{
    NSMutableCharacterSet *characterSet = [[NSMutableCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    
    [characterSet removeCharactersInString:@":#[]@!$&'()*+,;="];
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

- (NSString *)stringByRemovingURLEncoding
{
    return self.stringByRemovingPercentEncoding;
}

@end
