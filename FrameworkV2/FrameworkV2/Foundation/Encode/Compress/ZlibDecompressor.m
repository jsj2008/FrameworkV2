//
//  ZlibDecompressor.m
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "ZlibDecompressor.h"
#import <zlib.h>

@interface ZlibDecompressor ()
{
    NSMutableData *_decompressedData;
}

@property (nonatomic) NSMutableData *buffer;

@end


@implementation ZlibDecompressor

@synthesize decompressedData = _decompressedData;

- (instancetype)init
{
    if (self = [super init])
    {
        self.buffer = [[NSMutableData alloc] init];
        
        _decompressedData = [[NSMutableData alloc] init];
        
        self.status = ZlibDecompressing;
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    if (data.length > 0)
    {
        [self.decompressedData appendData:data];
    }
}

- (NSData *)undecompressedData
{
    return self.buffer;
}

- (void)cleanUndecompressedData
{
    self.buffer.length = 0;
}

@end


@interface DeflateDecompressor ()
{
    // zlib流
    z_stream _stream;
}

@end


@implementation DeflateDecompressor

- (void)dealloc
{
    inflateEnd(&_stream);
}

- (instancetype)init
{
    if (self = [super init])
    {
        _stream.zalloc = Z_NULL;
        
        _stream.zfree = Z_NULL;
        
        _stream.opaque = Z_NULL;
        
        _stream.avail_in = 0;
        
        _stream.next_in = Z_NULL;
        
        int code = inflateInit(&_stream);
        
        if (code != Z_OK)
        {
            self.status = ZlibDecompressError;
            
            self.error = [NSError ZlibDecompressionErrorWithCode:code description:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"")];
        }
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    if (data.length == 0)
    {
        return;
    }
    
    [self.buffer appendData:data];
    
    unsigned char *input = (unsigned char *)self.buffer.bytes;
    
    unsigned char output[1024];
    
    _stream.avail_in = (uInt)self.buffer.length;
    
    _stream.next_in = input;
    
    int code;
    
    int have;
    
    do {
        
        _stream.avail_out = 1024;
        
        _stream.next_out = output;
        
        code = inflate(&_stream, Z_NO_FLUSH);
        
        have = 1024 - _stream.avail_out;
        
        if (code == Z_OK || code == Z_BUF_ERROR)
        {
            if (have > 0)
            {
                [self.decompressedData appendBytes:output length:have];
            }
        }
        else if (code == Z_STREAM_END)
        {
            if (have > 0)
            {
                [self.decompressedData appendBytes:output length:have];
            }
            
            self.status = ZlibDecompressCompleted;
            
            [self.buffer appendBytes:_stream.next_in length:_stream.avail_in];
            
            break;
        }
        else if (code == Z_NEED_DICT || code == Z_DATA_ERROR || code == Z_STREAM_ERROR || code == Z_MEM_ERROR)
        {
            self.status = ZlibDecompressError;
            
            self.error = [NSError ZlibDecompressionErrorWithCode:code description:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"")];
        }
        
    } while (_stream.avail_out == 0 && self.status == ZlibDecompressing);
    
    self.buffer.length = 0;
}

@end


@interface GzipDecompressor ()
{
    // zlib流
    z_stream _stream;
    
    // gzip头
    char _dummy_head[2];
}

@property (nonatomic) BOOL dummyHeadUsed;

@end


@implementation GzipDecompressor

- (void)dealloc
{
    inflateEnd(&_stream);
}

- (instancetype)init
{
    if (self = [super init])
    {
        _stream.zalloc = Z_NULL;
        
        _stream.zfree = Z_NULL;
        
        _stream.opaque = Z_NULL;
        
        _stream.avail_in = 0;
        
        _stream.next_in = Z_NULL;
        
        _dummy_head[0] = 0x8 + 0x7 * 0x10;
        
        _dummy_head[1] = (((0x8 + 0x7 * 0x10) * 0x100 + 30) / 31 * 31) & 0xFF;
        
        int code = inflateInit2(&_stream, MAX_WBITS + 16);
        
        if (code != Z_OK)
        {
            self.status = ZlibDecompressError;
            
            self.error = [NSError ZlibDecompressionErrorWithCode:code description:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"")];
        }
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    if (data.length == 0)
    {
        return;
    }
    
    [self.buffer appendData:data];
    
    unsigned char *input = (unsigned char *)self.buffer.bytes;
    
    unsigned char output[1024];
    
    _stream.avail_in = (uInt)self.buffer.length;
    
    _stream.next_in = input;
    
    int code;
    
    int have;
    
    do {
        
        _stream.avail_out = 1024;
        
        _stream.next_out = output;
        
        code = inflate(&_stream, Z_NO_FLUSH);
        
        have = 1024 - _stream.avail_out;
        
        if (code == Z_OK || code == Z_BUF_ERROR)
        {
            if (have > 0)
            {
                [self.decompressedData appendBytes:output length:have];
            }
        }
        else if (code == Z_STREAM_END)
        {
            if (have > 0)
            {
                [self.decompressedData appendBytes:output length:have];
            }
            
            self.status = ZlibDecompressCompleted;
            
            [self.buffer appendBytes:_stream.next_in length:_stream.avail_in];
            
            break;
        }
        else if (code == Z_NEED_DICT || code == Z_STREAM_ERROR || code == Z_MEM_ERROR)
        {
            self.status = ZlibDecompressError;
            
            self.error = [NSError ZlibDecompressionErrorWithCode:code description:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"")];
        }
        else if (code == Z_DATA_ERROR)
        {
            if (self.dummyHeadUsed)
            {
                self.status = ZlibDecompressError;
                
                self.error = [NSError ZlibDecompressionErrorWithCode:code description:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"")];
            }
            else
            {
                _stream.avail_in = sizeof(_dummy_head);
                
                _stream.next_in = (Bytef *)_dummy_head;
            }
        }
        
    } while (_stream.avail_out == 0 && self.status == ZlibDecompressing);
    
    [self.buffer setLength:0];
}

@end


NSString * const ZlibDecompressionErrorDomain = @"ZlibDecompressionError";


@implementation NSError (ZlibDecompression)

+ (NSError *)ZlibDecompressionErrorWithCode:(int)code description:(NSString *)description
{
    return [NSError errorWithDomain:ZlibDecompressionErrorDomain code:code userInfo:description ? [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey] : nil];
}

@end
