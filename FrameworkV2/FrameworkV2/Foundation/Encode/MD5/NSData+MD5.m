//
//  NSData+MD5.m
//  FrameworkV1
//
//  Created by ww on 16/4/21.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (MD5)

- (NSString *)stringByAddingMD5Encoding
{
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_CTX context;
    
    CC_MD5_Init(&context);
    
    CC_MD5_Update(&context, [self bytes], (CC_LONG)[self length]);
    
    CC_MD5_Final(md, &context);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X", md[i]];
    }
    
    return [hash uppercaseString];
}

@end
