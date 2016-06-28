//
//  HTTPMessageBodySerializer.m
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageBodySerializer.h"

@interface HTTPMessageBodySerializer ()

@property (nonatomic) NSInputStream *dataStream;

@property (nonatomic) NSMutableData *buffer;

@end


@implementation HTTPMessageBodySerializer

- (void)dealloc
{
    [self.dataStream close];
}

- (instancetype)initWithDataStream:(NSInputStream *)dataStream
{
    if (self = [super init])
    {
        self.dataStream = dataStream;
        
        [self.dataStream open];
        
        self.buffer = [[NSMutableData alloc] init];
    }
    
    return self;
}

@end


@implementation HTTPMessageLengthFixedBodySerializer

- (NSData *)dataWithMaxLength:(NSUInteger)maxLength
{
    if (maxLength == 0)
    {
        return nil;
    }
    
    uint8_t buffer[maxLength];
    
    NSUInteger length = [self.dataStream read:buffer maxLength:maxLength];
    
    NSData *data = (length > 0) ? [[NSData alloc] initWithBytes:buffer length:length] : nil;
        
    if (self.dataStream.streamStatus == NSStreamStatusAtEnd)
    {
        self.status = HTTPMessageSerializeCompleted;
    }
    else if (self.dataStream.streamStatus == NSStreamStatusError)
    {
        self.status = HTTPMessageSerializeError;
        
        self.error = self.dataStream.streamError;
    }
    
    return data;
}

@end


NSUInteger const HTTPMessageBodyChunkDefaultSerializeLength = 4 * 1024;


@implementation HTTPMessageChunkedBodySerializer

- (NSData *)dataWithMaxLength:(NSUInteger)maxLength
{
    if (maxLength == 0)
    {
        return nil;
    }
    
    if (self.buffer.length >= maxLength)
    {
        NSData *data = [self.buffer subdataWithRange:NSMakeRange(0, maxLength)];
        
        [self.buffer replaceBytesInRange:NSMakeRange(0, maxLength) withBytes:NULL length:0];
        
        if ((self.dataStream.streamStatus == NSStreamStatusAtEnd && self.buffer.length == 0))
        {
            self.status = HTTPMessageSerializeCompleted;
        }
        
        return data;
    }
    
    NSUInteger bufferLength = MAX(maxLength, HTTPMessageBodyChunkDefaultSerializeLength);
    
    uint8_t buffer[bufferLength];
    
    NSInteger length = [self.dataStream read:buffer maxLength:bufferLength];
    
    if (length > 0)
    {
        NSString *sizeString = [NSString stringWithFormat:@"%lx\r\n", (long)length];
        
        NSString *endString = @"\r\n";
        
        [self.buffer appendData:[sizeString dataUsingEncoding:NSASCIIStringEncoding]];
        
        [self.buffer appendBytes:buffer length:length];
        
        [self.buffer appendData:[endString dataUsingEncoding:NSASCIIStringEncoding]];
    }
    
    NSInteger dataLength = MIN(maxLength, self.buffer.length);
    
    NSData *data = [self.buffer subdataWithRange:NSMakeRange(0, dataLength)];
    
    [self.buffer replaceBytesInRange:NSMakeRange(0, dataLength) withBytes:NULL length:0];
    
    if (self.dataStream.streamStatus == NSStreamStatusAtEnd && self.buffer.length == 0)
    {
        self.status = HTTPMessageSerializeCompleted;
    }
    else if (self.dataStream.streamStatus == NSStreamStatusError)
    {
        self.status = HTTPMessageSerializeError;
        
        self.error = self.dataStream.streamError;
    }
    
    return data;
}

@end
