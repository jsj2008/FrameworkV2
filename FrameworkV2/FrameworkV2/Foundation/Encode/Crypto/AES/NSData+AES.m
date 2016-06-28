//
//  NSData+AES.m
//  FrameworkV1
//
//  Created by ww on 16/4/21.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSData+AES.h"

@implementation NSData (AES)

- (NSData *)dataByAddingAES128CryptingByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv
{
    // 'key' should be 16 bytes for AES128
    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    
    bzero( keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    [key getBytes:keyPtr length:[key length]];
    
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = kCCSuccess;
    
    NSData *cryptedData = nil;
    
    if ([iv length])
    {
        char ivPtr[kCCBlockSizeAES128 + 1]; // room for terminator (unused)
        
        bzero( ivPtr, sizeof(ivPtr)); // fill with zeroes (for padding)
        
        [iv getBytes:ivPtr length:[iv length]];
        
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES128,
                              ivPtr /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    else
    {
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES128,
                              NULL /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    
    
    
    if( cryptStatus == kCCSuccess )
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        cryptedData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    
    return cryptedData;
}

- (NSData *)dataByAddingAES256CryptingByOperation:(CCOperation)operation withKey:(NSData *)key iv:(NSData *)iv
{
    // 'key' should be 16 bytes for AES128
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    
    bzero( keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    [key getBytes:keyPtr length:[key length]];
    
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc( bufferSize );
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = kCCSuccess;
    
    NSData *cryptedData = nil;
    
    if ([iv length])
    {
        char ivPtr[kCCBlockSizeAES128 + 1]; // room for terminator (unused)
        
        bzero( ivPtr, sizeof(ivPtr)); // fill with zeroes (for padding)
        
        [iv getBytes:ivPtr length:[iv length]];
        
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES256,
                              ivPtr /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    else
    {
        cryptStatus = CCCrypt(operation, kCCAlgorithmAES128,
                              kCCOptionECBMode|kCCOptionPKCS7Padding,
                              keyPtr, kCCKeySizeAES256,
                              NULL /* initialization vector (optional) */,
                              [self bytes], dataLength, /* input */
                              buffer, bufferSize, /* output */
                              &numBytesEncrypted);
    }
    
    
    
    if( cryptStatus == kCCSuccess )
    {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        cryptedData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free( buffer ); //free the buffer
    
    return cryptedData;
}

@end
