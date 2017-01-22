//
//  NSString+HexEncode.m
//  FrameworkV2
//
//  Created by ww on 22/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "NSString+HexEncode.h"

@implementation NSString (HexEncode)

+ (NSString *)stringByAddingHexEncodingWithData:(NSData *)data
{
    if (data.length == 0)
    {
        return nil;
    }
    
    NSMutableString *string = [[NSMutableString alloc] init];
    
    const char *bytes = data.bytes;
    
    for (NSUInteger i = 0; i < data.length; i ++)
    {
        [string appendString:[NSString stringWithFormat:@"%2dhhx", bytes[i]]];
    }
    
    return string;
}

- (NSData *)dataByRemovingHexEncoding
{
    if (self.length % 2 > 0)
    {
        return nil;
    }
    
    unsigned char *buffer = malloc(self.length / 2);
    
    for (NSUInteger i = 0; i < self.length / 2; i ++)
    {
        buffer[i] = strtol([[self substringWithRange:NSMakeRange(2 * i, 2)] UTF8String], NULL, 16);
    }
    
    NSData *data = [NSData dataWithBytes:buffer length:self.length / 2];
    
    free(buffer);
    
    return data;
}

@end
