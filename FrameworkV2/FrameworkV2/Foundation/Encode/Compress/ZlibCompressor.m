//
//  ZlibCompressor.m
//  HS
//
//  Created by ww on 16/6/6.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "ZlibCompressor.h"
#import <zlib.h>

@interface ZlibCompressor ()
{
    NSMutableData *_compressedData;
}

@property (nonatomic) NSMutableData *buffer;

@end


@implementation ZlibCompressor

@synthesize compressedData = _compressedData;

- (instancetype)init
{
    if (self = [super init])
    {
        self.buffer = [[NSMutableData alloc] init];
        
        _compressedData = [[NSMutableData alloc] init];
        
        self.status = ZlibCompressing;
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    if (data.length > 0)
    {
        [self.compressedData appendData:data];
    }
}

- (void)finishCompressing
{
    self.status = ZlibCompressCompleted;
}

- (NSData *)uncompressedData
{
    return self.buffer;
}

- (void)cleanUncompressedData
{
    self.buffer.length = 0;
}

@end


@interface DeflateCompressor ()
{
    // zlib流
    z_stream _stream;
}

- (void)runWithEnd:(BOOL)end;

@end


@implementation DeflateCompressor

- (void)dealloc
{
    deflateEnd(&_stream);
}

- (instancetype)init
{
    if (self = [super init])
    {
        _stream.zalloc = Z_NULL;
        
        _stream.zfree = Z_NULL;
        
        _stream.opaque = Z_NULL;
        
        int code = deflateInit(&_stream, Z_DEFAULT_COMPRESSION);
        
        if (code != Z_OK)
        {
            self.error = [NSError errorWithDomain:ZlibCompressionErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
        }
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    if (data.length > 0)
    {
        [self.buffer appendData:data];
        
        [self runWithEnd:NO];
    }
}

- (void)finishCompressing
{
    [self runWithEnd:YES];
}

- (void)runWithEnd:(BOOL)end
{
    _stream.avail_in = (uInt)self.buffer.length;
    
    _stream.next_in = (unsigned char *)self.buffer.bytes;
    
    NSUInteger outputSize = deflateBound(&_stream, self.buffer.length);
    
    int flush = end ? Z_FINISH : Z_NO_FLUSH;
    
    int code;
    
    do {
        
        unsigned char output[outputSize];
        
        _stream.avail_out = (uInt)outputSize;
        
        _stream.next_out = output;
        
        code = deflate(&_stream, flush);
        
        NSInteger have = outputSize - _stream.avail_out;
        
        if (code == Z_OK || code == Z_BUF_ERROR)
        {
            if (have > 0)
            {
                [self.compressedData appendBytes:output length:have];
            }
        }
        else if (code == Z_STREAM_END)
        {
            if (have > 0)
            {
                [self.compressedData appendBytes:output length:have];
            }
            
            self.status = ZlibCompressCompleted;
        }
        else if (code == Z_STREAM_ERROR)
        {
            self.status = ZlibCompressError;
            
            self.error = [NSError errorWithDomain:ZlibCompressionErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
        }
        
    } while (_stream.avail_out == 0 && self.status == ZlibCompressing);
    
    self.buffer.length = 0;
}

@end


@interface GzipCompressor ()
{
    // zlib流
    z_stream _stream;
}

- (void)runWithEnd:(BOOL)end;

@end


@implementation GzipCompressor

- (void)dealloc
{
    deflateEnd(&_stream);
}

- (instancetype)init
{
    if (self = [super init])
    {
        _stream.zalloc = Z_NULL;
        
        _stream.zfree = Z_NULL;
        
        _stream.opaque = Z_NULL;
        
        int code = deflateInit2(&_stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, 8, Z_DEFAULT_STRATEGY);
        
        if (code != Z_OK)
        {
            self.error = [NSError errorWithDomain:ZlibCompressionErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
        }
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    if (data.length > 0)
    {
        [self.buffer appendData:data];
        
        [self runWithEnd:NO];
    }
}

- (void)finishCompressing
{
    [self runWithEnd:YES];
}

- (void)runWithEnd:(BOOL)end
{
    _stream.avail_in = (uInt)self.buffer.length;
    
    _stream.next_in = (unsigned char *)self.buffer.bytes;
    
    NSUInteger outputSize = deflateBound(&_stream, self.buffer.length);
    
    int flush = end ? Z_FINISH : Z_NO_FLUSH;
    
    int code;
    
    do {
        
        unsigned char output[outputSize];
        
        _stream.avail_out = (uInt)outputSize;
        
        _stream.next_out = output;
        
        code = deflate(&_stream, flush);
        
        NSInteger have = outputSize - _stream.avail_out;
        
        if (code == Z_OK || code == Z_BUF_ERROR)
        {
            if (have > 0)
            {
                [self.compressedData appendBytes:output length:have];
            }
        }
        else if (code == Z_STREAM_END)
        {
            if (have > 0)
            {
                [self.compressedData appendBytes:output length:have];
            }
            
            self.status = ZlibCompressCompleted;
        }
        else if (code == Z_STREAM_ERROR)
        {
            self.status = ZlibCompressError;
            
            self.error = [NSError errorWithDomain:ZlibCompressionErrorDomain code:code userInfo:[NSDictionary dictionaryWithObject:(_stream.msg ? [NSString stringWithUTF8String:_stream.msg] : @"") forKey:NSLocalizedDescriptionKey]];
        }
        
    } while (_stream.avail_out == 0 && self.status == ZlibCompressing);
    
    self.buffer.length = 0;
}

@end


NSString * const ZlibCompressionErrorDomain = @"ZlibCompressionError";


@implementation NSError (ZlibCompression)

+ (NSError *)ZlibCompressionErrorWithCode:(int)code description:(NSString *)description
{
    return [NSError errorWithDomain:ZlibCompressionErrorDomain code:code userInfo:description ? [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey] : nil];
}

@end
