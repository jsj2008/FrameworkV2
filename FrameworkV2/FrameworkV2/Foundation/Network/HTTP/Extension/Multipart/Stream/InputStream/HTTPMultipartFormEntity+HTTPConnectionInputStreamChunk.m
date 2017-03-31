//
//  HTTPMultipartFormEntity+HTTPConnectionInputStreamChunk.m
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPMultipartFormEntity+HTTPConnectionInputStreamChunk.h"
#import "HTTPMultipartFormPartContentDisposition.h"

@implementation HTTPMultipartFormEntity (HTTPConnectionInputStreamChunk)

- (NSArray<HTTPConnectionInputStreamChunk *> *)inputStreamChunks
{
    NSMutableArray *chunks = [[NSMutableArray alloc] init];
    
    NSData *headerSeparatorData = [[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *footerSeparatorData = [[NSString stringWithFormat:@"\r\n--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *contentSeparatorData = [[NSString stringWithFormat:@"\r\n--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding];
    
    HTTPConnectionInputStreamDataChunk *headerSeparatorChunk = [[HTTPConnectionInputStreamDataChunk alloc] initWithData:headerSeparatorData];
    
    HTTPConnectionInputStreamDataChunk *footerSeparatorChunk = [[HTTPConnectionInputStreamDataChunk alloc] initWithData:footerSeparatorData];
    
    [chunks addObject:headerSeparatorChunk];
    
    for (int i = 0; i < [self.parts count]; i ++)
    {
        HTTPMultipartFormPart *part = [self.parts objectAtIndex:i];
        
        NSArray *partChunks = [part inputStreamChunks];
        
        if ([partChunks count] > 0)
        {
            [chunks addObjectsFromArray:partChunks];
        }
        
        if (i < [self.parts count] - 1)
        {
            HTTPConnectionInputStreamDataChunk *contentSeparatorChunk = [[HTTPConnectionInputStreamDataChunk alloc] initWithData:contentSeparatorData];
            
            [chunks addObject:contentSeparatorChunk];
        }
    }
    
    [chunks addObject:footerSeparatorChunk];
    
    return chunks;
}

@end


@implementation HTTPMultipartFormPart (HTTPConnectionInputStreamChunk)

- (NSArray<HTTPConnectionInputStreamChunk *> *)inputStreamChunks
{
    return nil;
}

@end


@implementation HTTPMultipartFormDataPart (HTTPConnectionInputStreamChunk)

- (NSArray<HTTPConnectionInputStreamChunk *> *)inputStreamChunks
{
    NSMutableArray *chunks = [[NSMutableArray alloc] init];
    
    HTTPMultipartFormPartContentDisposition *contentDisposition = [[HTTPMultipartFormPartContentDisposition alloc] init];
    
    contentDisposition.type = @"form-data";
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    
    if (self.name)
    {
        HTTPMultipartFormPartContentDispositionKeyValuePair *pair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] init];
        
        pair.key = @"name";
        
        pair.value = self.name;
        
        [pairs addObject:pair];
    }
    
    for (NSString *key in [self.dispositionExtensions allKeys])
    {
        NSString *value = [self.dispositionExtensions objectForKey:key];
        
        if (key && value)
        {
            HTTPMultipartFormPartContentDispositionKeyValuePair *pair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] init];
            
            pair.key = key;
            
            pair.value = value;
            
            [pairs addObject:pair];
        }
    }
    
    contentDisposition.keyValuePairs = pairs;
    
    NSMutableString *headerFieldsString = [NSMutableString stringWithFormat:@"Content-Disposition:%@\r\n", [contentDisposition string]];
    
    if (self.contentType)
    {
        [headerFieldsString appendFormat:@"Content-Type:%@\r\n", self.contentType];
    }
    
    for (NSString *key in [self.additionalHeaderFields allKeys])
    {
        NSString *value = [self.additionalHeaderFields objectForKey:key];
        
        [headerFieldsString appendFormat:@"%@:%@\r\n", key, value];
    }
    
    [headerFieldsString appendString:@"\r\n"];
    
    [chunks addObject:[[HTTPConnectionInputStreamDataChunk alloc] initWithData:[headerFieldsString dataUsingEncoding:NSUTF8StringEncoding]]];
    
    if (self.data)
    {
        HTTPConnectionInputStreamDataChunk *dataChunk = [[HTTPConnectionInputStreamDataChunk alloc] initWithData:self.data];
        
        [chunks addObject:dataChunk];
    }
    
    return chunks;
}

@end


@implementation HTTPMultipartFormFilePart (HTTPConnectionInputStreamChunk)

- (NSArray<HTTPConnectionInputStreamChunk *> *)inputStreamChunks
{
    NSMutableArray *chunks = [[NSMutableArray alloc] init];
    
    HTTPMultipartFormPartContentDisposition *contentDisposition = [[HTTPMultipartFormPartContentDisposition alloc] init];
    
    contentDisposition.type = @"form-data";
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    
    if (self.name)
    {
        HTTPMultipartFormPartContentDispositionKeyValuePair *pair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] init];
        
        pair.key = @"name";
        
        pair.value = self.name;
        
        [pairs addObject:pair];
    }
    
    if (self.fileName)
    {
        HTTPMultipartFormPartContentDispositionKeyValuePair *pair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] init];
        
        pair.key = @"filename";
        
        pair.value = self.fileName;
        
        [pairs addObject:pair];
    }
    
    for (NSString *key in [self.dispositionExtensions allKeys])
    {
        NSString *value = [self.dispositionExtensions objectForKey:key];
        
        if (key && value)
        {
            HTTPMultipartFormPartContentDispositionKeyValuePair *pair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] init];
            
            pair.key = key;
            
            pair.value = value;
            
            [pairs addObject:pair];
        }
    }
    
    contentDisposition.keyValuePairs = pairs;
    
    NSMutableString *headerFieldsString = [NSMutableString stringWithFormat:@"Content-Disposition:%@\r\n", [contentDisposition string]];
    
    if (self.contentType)
    {
        [headerFieldsString appendFormat:@"Content-Type:%@\r\n", self.contentType];
    }
    
    for (NSString *key in [self.additionalHeaderFields allKeys])
    {
        NSString *value = [self.additionalHeaderFields objectForKey:key];
        
        [headerFieldsString appendFormat:@"%@:%@\r\n", key, value];
    }
    
    [headerFieldsString appendString:@"\r\n"];
    
    [chunks addObject:[[HTTPConnectionInputStreamDataChunk alloc] initWithData:[headerFieldsString dataUsingEncoding:NSUTF8StringEncoding]]];
    
    if (self.filePath)
    {
        HTTPConnectionInputStreamFileChunk *fileChunk = [[HTTPConnectionInputStreamFileChunk alloc] initWithFilePath:self.filePath];
        
        [chunks addObject:fileChunk];
    }
    
    return chunks;
}

@end


@implementation HTTPMultipartFormEntityPart (HTTPConnectionInputStreamChunk)

- (NSArray<HTTPConnectionInputStreamChunk *> *)inputStreamChunks
{
    NSMutableArray *chunks = [[NSMutableArray alloc] init];
    
    HTTPMultipartFormPartContentDisposition *contentDisposition = [[HTTPMultipartFormPartContentDisposition alloc] init];
    
    contentDisposition.type = @"form-data";
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    
    if (self.name)
    {
        HTTPMultipartFormPartContentDispositionKeyValuePair *pair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] init];
        
        pair.key = @"name";
        
        pair.value = self.name;
        
        [pairs addObject:pair];
    }
    
    for (NSString *key in [self.dispositionExtensions allKeys])
    {
        NSString *value = [self.dispositionExtensions objectForKey:key];
        
        if (key && value)
        {
            HTTPMultipartFormPartContentDispositionKeyValuePair *pair = [[HTTPMultipartFormPartContentDispositionKeyValuePair alloc] init];
            
            pair.key = key;
            
            pair.value = value;
            
            [pairs addObject:pair];
        }
    }
    
    contentDisposition.keyValuePairs = pairs;
    
    NSMutableString *headerFieldsString = [NSMutableString stringWithFormat:@"Content-Disposition:%@\r\n", [contentDisposition string]];
    
    if (self.entity)
    {
        [headerFieldsString appendFormat:@"Content-Type:multipart/mixed,boundary=%@\r\n", self.entity.boundary];
    }
    
    [headerFieldsString appendString:@"\r\n"];
    
    [chunks addObject:[[HTTPConnectionInputStreamDataChunk alloc] initWithData:[headerFieldsString dataUsingEncoding:NSUTF8StringEncoding]]];
    
    if (self.entity)
    {
        NSArray *entityChunks = [self.entity inputStreamChunks];
        
        if ([entityChunks count] > 0)
        {
            [chunks addObjectsFromArray:entityChunks];
        }
    }
    
    return chunks;
}

@end
