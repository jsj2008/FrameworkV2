//
//  NSFileHandle+MD5.m
//  FrameworkV1
//
//  Created by ww on 16/4/21.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSFileHandle+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSFileHandle (MD5)

- (NSString *)stringByAddingMD5Encoding
{
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_CTX context;
    
    CC_MD5_Init(&context);
    
    NSData *data = nil;
    
    do {
        
        @autoreleasepool
        {
            data = [self readDataOfLength:1024];
            
            CC_MD5_Update(&context, [data bytes], (CC_LONG)[data length]);
        }
        
    } while ([data length]);
    
    CC_MD5_Final(md, &context);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X", md[i]];
    }
    
    return [hash uppercaseString];
}

@end
