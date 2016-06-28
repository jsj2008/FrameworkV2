//
//  HTTPConnectionInputStreamChunk.m
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnectionInputStreamChunk.h"

@implementation HTTPConnectionInputStreamChunk

- (id)copyWithZone:(NSZone *)zone
{
    HTTPConnectionInputStreamChunk *one = [[HTTPConnectionInputStreamChunk allocWithZone:zone] init];
    
    return one;
}

- (NSInputStream *)inputStream
{
    return nil;
}

@end


@interface HTTPConnectionInputStreamDataChunk ()
{
    NSData *_data;
}

@end


@implementation HTTPConnectionInputStreamDataChunk

@synthesize data = _data;

- (instancetype)initWithData:(NSData *)data
{
    if (self = [super init])
    {
        _data = data;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[HTTPConnectionInputStreamDataChunk allocWithZone:zone] initWithData:self.data];
}

- (NSInputStream *)inputStream
{
    return self.data ? [[NSInputStream alloc] initWithData:self.data] : nil;
}

@end


@interface HTTPConnectionInputStreamFileChunk ()
{
    NSString *_filePath;
}

@end


@implementation HTTPConnectionInputStreamFileChunk

@synthesize filePath = _filePath;

- (instancetype)initWithFilePath:(NSString *)filePath
{
    if (self = [super init])
    {
        _filePath = [filePath copy];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[HTTPConnectionInputStreamFileChunk allocWithZone:zone] initWithFilePath:self.filePath];
}

- (NSInputStream *)inputStream
{
    return self.filePath ? [[NSInputStream alloc] initWithFileAtPath:self.filePath] : nil;
}

@end


@interface HTTPConnectionInputStreamStreamChunk ()
{
    NSInputStream<NSCopying> *_stream;
}

@end


@implementation HTTPConnectionInputStreamStreamChunk

@synthesize stream = _stream;

- (instancetype)initWithStream:(NSInputStream<NSCopying> *)stream
{
    if (self = [super init])
    {
        _stream = stream;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[HTTPConnectionInputStreamStreamChunk alloc] initWithStream:[self.stream copy]];
}

- (NSInputStream *)inputStream
{
    return self.stream;
}

@end
