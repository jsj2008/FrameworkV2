//
//  NSData+_3DES.m
//  FrameworkV2
//
//  Created by ww on 22/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "NSData+_3DES.h"

@implementation NSData (_3DES)

- (NSData *)dataByAdding3DESEncodingByOperation:(CCOperation)operation withOptions:(CCOptions)options key:(NSData *)key iv:(NSData *)iv
{
    size_t bufferSize = (self.length + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    
    uint8_t *buffer = malloc(bufferSize * sizeof(uint8_t));
    
    memset(buffer, 0x0, bufferSize);
    
    size_t dataNumber = 0;
    
    NSData *data = nil;
    
    if (CCCrypt(operation, kCCAlgorithm3DES, options, key.bytes, kCCKeySize3DES, iv.bytes, self.bytes, self.length, buffer, bufferSize, &dataNumber) == kCCSuccess)
    {
        data = [NSData dataWithBytes:buffer length:dataNumber];
    }
    
    free(buffer);
    
    return data;
}

@end
