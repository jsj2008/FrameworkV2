//
//  HTTPMessageBodyParser.m
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageBodyParser.h"
#import "HTTPMessageError.h"

@interface HTTPMessageBodyParser ()
{
    NSMutableData *_parsedBodyData;
}

@end


@implementation HTTPMessageBodyParser

@synthesize parsedBodyData = _parsedBodyData;

- (instancetype)init
{
    if (self = [super init])
    {
        _parsedBodyData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (NSData *)unparsedData
{
    return self.buffer;
}

- (void)cleanUnparsedData
{
    self.buffer.length = 0;
}

@end


@interface HTTPMessageLengthFixedBodyParser ()
{
    unsigned long long _length;
}

@property (nonatomic) unsigned long long parsedLength;

@end


@implementation HTTPMessageLengthFixedBodyParser

@synthesize length = _length;

- (instancetype)initWithLength:(unsigned long long)length
{
    if (self = [super init])
    {
        _length = length;
        
        if (length == 0)
        {
            self.status = HTTPMessageParseCompleted;
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
    
    if (self.parsedLength < self.length)
    {
        NSUInteger parsingLength = MIN(self.length - self.parsedLength, self.buffer.length);
        
        NSData *data = [self.buffer subdataWithRange:NSMakeRange(0, parsingLength)];
        
        if (data.length > 0)
        {
            [self.parsedBodyData appendData:data];
            
            [self.buffer replaceBytesInRange:NSMakeRange(0, parsingLength) withBytes:NULL length:0];
        }
        
        self.parsedLength += data.length;
    }
    
    if (self.parsedLength >= self.length)
    {
        self.status = HTTPMessageParseCompleted;
    }
}

@end


@interface HTTPMessageChunkedBodyParser ()

@property (nonatomic) HTTPMessageBodyChunkParser *chunkParser;

@end


@implementation HTTPMessageChunkedBodyParser

- (void)addData:(NSData *)data
{
    if (data.length == 0)
    {
        return;
    }
    
    [self.buffer appendData:data];
    
    if (!_chunkParser)
    {
        self.chunkParser = [[HTTPMessageBodyChunkParser alloc] init];
    }
    
    if (self.chunkParser.status == HTTPMessageParsing)
    {
        [self.chunkParser addData:self.buffer];
    }
    
    if (self.chunkParser.status == HTTPMessageParsing)
    {
        return;
    }
    else if (self.chunkParser.status == HTTPMessageParseCompleted)
    {
        if (self.chunkParser.parsedData.length > 0)
        {
            [self.parsedBodyData appendData:self.chunkParser.parsedData];
            
            self.chunkParser.parsedData.length = 0;
        }
        
        NSData *unparsedData = [self.chunkParser unparsedData];
        
        if (unparsedData.length > 0)
        {
            [self.buffer appendData:unparsedData];
            
            [self.chunkParser cleanUnparsedData];
        }
        
        if ([self.chunkParser isEndChunk])
        {
            self.status = HTTPMessageParseCompleted;
        }
        
        self.chunkParser = nil;
    }
    else if (self.chunkParser.status == HTTPMessageParseError)
    {
        self.status = HTTPMessageParseError;
        
        self.error = self.chunkParser.error;
    }
}

@end


@interface HTTPMessageBodyChunkParser ()
{
    NSMutableData *_parsedData;
}

@property (nonatomic) NSInteger chunkSize;

@end


@implementation HTTPMessageBodyChunkParser

@synthesize parsedData = _parsedData;

- (instancetype)init
{
    if (self = [super init])
    {
        self.chunkSize = -1;
        
        _parsedData = [[NSMutableData alloc] init];
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
    
    NSData *CRLFData = [@"\r\n" dataUsingEncoding:NSASCIIStringEncoding];
    
    if (self.chunkSize < 0)
    {
        NSRange CRLFRange = [self.buffer rangeOfData:CRLFData options:0 range:NSMakeRange(0, self.buffer.length)];
        
        if (CRLFRange.location != NSNotFound)
        {
            NSData *sizeData = [self.buffer subdataWithRange:NSMakeRange(0, CRLFRange.location)];
            
            if (sizeData.length > 0)
            {
                NSString *sizeString = [[NSString alloc] initWithData:sizeData encoding:NSASCIIStringEncoding];
                
                char *pEnd;
                
                long long size = strtoll([sizeString UTF8String], &pEnd, 16);
                
                if (*pEnd == 0 && size >= 0)
                {
                    self.chunkSize = size;
                    
                    [self.buffer replaceBytesInRange:NSMakeRange(0, CRLFRange.location + CRLFRange.length) withBytes:NULL length:0];
                }
            }
        }
        else
        {
            return;
        }
    }
    
    if (self.chunkSize < 0)
    {
        self.status = HTTPMessageParseError;
        
        self.error = [NSError HTTPMessageErrorWithCode:HTTPMessageErrorUnknownBodySize];
    }
    else
    {
        if (self.buffer.length >= self.chunkSize + CRLFData.length)
        {
            NSData *chunkData = [self.buffer subdataWithRange:NSMakeRange(0, self.chunkSize + CRLFData.length)];
            
            [self.buffer replaceBytesInRange:NSMakeRange(0, self.chunkSize + CRLFData.length) withBytes:NULL length:0];
            
            if ([[chunkData subdataWithRange:NSMakeRange(chunkData.length - CRLFData.length, CRLFData.length)] isEqualToData:CRLFData])
            {
                self.status = HTTPMessageParseCompleted;
                
                [self.parsedData appendData:[chunkData subdataWithRange:NSMakeRange(0, self.chunkSize)]];
            }
            else
            {
                self.status = HTTPMessageParseError;
                
                self.error = [NSError HTTPMessageErrorWithCode:HTTPMessageErrorUnknownBodySize];
            }
        }
    }
}

- (BOOL)isEndChunk
{
    return self.chunkSize == 0;
}

- (NSData *)unparsedData
{
    return self.buffer;
}

- (void)cleanUnparsedData
{
    self.buffer.length = 0;
}

@end
