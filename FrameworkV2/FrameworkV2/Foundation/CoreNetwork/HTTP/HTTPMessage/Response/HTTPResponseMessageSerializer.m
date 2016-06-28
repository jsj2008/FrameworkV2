//
//  HTTPResponseMessageSerializer.m
//  HS
//
//  Created by ww on 16/5/23.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPResponseMessageSerializer.h"
#import "HTTPResponseMessageHeaderSerializer.h"
#import "HTTPMessageBodySerializer.h"

@interface HTTPResponseMessageSerializer ()
{
    long long _bodySize;
    
    unsigned long long _consumedBodySize;
    
    unsigned long long _consumedBodySizeInLastRead;
}

@property (nonatomic) HTTPResponseMessageHeaderSerializer *headerSerializer;

@property (nonatomic) HTTPMessageBodySerializer *bodySerializer;

@end


@implementation HTTPResponseMessageSerializer

@synthesize bodySize = _bodySize;

@synthesize consumedBodySize = _consumedBodySize;

@synthesize consumedBodySizeInLastRead = _consumedBodySizeInLastRead;

- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader
{
    if (self = [super init])
    {
        HTTPResponseHeader *validResponseHeader = [responseHeader copy];
        
        NSMutableDictionary *headerFields = (responseHeader.headerFields.count > 0) ? [[NSMutableDictionary alloc] initWithDictionary:responseHeader.headerFields] : [[NSMutableDictionary alloc] init];
        
        [headerFields removeObjectForKey:@"Content-Length"];
        
        [headerFields removeObjectForKey:@"Transfer-Encoding"];
        
        validResponseHeader.headerFields = headerFields;
        
        self.headerSerializer = [[HTTPResponseMessageHeaderSerializer alloc] initWithResponseHeader:validResponseHeader];
        
        _bodySize = 0;
    }
    
    return self;
}

- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader bodyData:(NSData *)bodyData
{
    if (self = [super init])
    {
        HTTPResponseHeader *validResponseHeader = [responseHeader copy];
        
        NSMutableDictionary *headerFields = (responseHeader.headerFields.count > 0) ? [[NSMutableDictionary alloc] initWithDictionary:responseHeader.headerFields] : [[NSMutableDictionary alloc] init];
        
        if (bodyData.length > 0)
        {
            [headerFields setObject:[NSString stringWithFormat:@"%lu", (unsigned long)bodyData.length] forKey:@"Content-Length"];
        }
        else
        {
            [headerFields removeObjectForKey:@"Content-Length"];
        }
        
        [headerFields removeObjectForKey:@"Transfer-Encoding"];
        
        validResponseHeader.headerFields = headerFields;
        
        self.headerSerializer = [[HTTPResponseMessageHeaderSerializer alloc] initWithResponseHeader:validResponseHeader];
        
        if (bodyData.length > 0)
        {
            self.bodySerializer = [[HTTPMessageLengthFixedBodySerializer alloc] initWithDataStream:[NSInputStream inputStreamWithData:bodyData]];
        }
        
        _bodySize = bodyData.length;
    }
    
    return self;
}

- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader bodyStream:(NSInputStream *)bodyStream
{
    if (self = [super init])
    {
        HTTPResponseHeader *validResponseHeader = [responseHeader copy];
        
        NSMutableDictionary *headerFields = (responseHeader.headerFields.count > 0) ? [[NSMutableDictionary alloc] initWithDictionary:responseHeader.headerFields] : [[NSMutableDictionary alloc] init];
        
        [headerFields setObject:@"chunked" forKey:@"Transfer-Encoding"];
        
        [headerFields removeObjectForKey:@"Content-Length"];
        
        validResponseHeader.headerFields = headerFields;
        
        self.headerSerializer = [[HTTPResponseMessageHeaderSerializer alloc] initWithResponseHeader:validResponseHeader];
        
        self.bodySerializer = [[HTTPMessageChunkedBodySerializer alloc] initWithDataStream:bodyStream];
        
        _bodySize = -1;
    }
    
    return self;
}

- (NSData *)dataWithMaxLength:(NSUInteger)maxLength
{
    if (maxLength == 0)
    {
        return nil;
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    if (self.headerSerializer.status == HTTPMessageSerializing)
    {
        NSData *headerData = [self.headerSerializer dataWithMaxLength:maxLength];
        
        if (headerData.length > 0)
        {
            [data appendData:headerData];
        }
    }
    
    if (self.headerSerializer.status == HTTPMessageSerializing)
    {
        return data;
    }
    else if (self.headerSerializer.status == HTTPMessageSerializeCompleted)
    {
        if (data.length == maxLength)
        {
            return data;
        }
    }
    else if (self.headerSerializer.status == HTTPMessageSerializeError)
    {
        self.status = HTTPMessageSerializeError;
        
        self.error = self.headerSerializer.error;
        
        return nil;
    }
    
    if (!self.bodySerializer)
    {
        self.status = HTTPMessageSerializeCompleted;
        
        return data;
    }
    else if (self.bodySerializer.status == HTTPMessageSerializing)
    {
        NSData *bodyData = [self.bodySerializer dataWithMaxLength:maxLength - data.length];
        
        if (bodyData.length > 0)
        {
            [data appendData:bodyData];
            
            _consumedBodySizeInLastRead = bodyData.length;
            
            _consumedBodySize += bodyData.length;
        }
    }
    
    if (self.bodySerializer.status == HTTPMessageSerializing)
    {
        return data;
    }
    else if (self.bodySerializer.status == HTTPMessageSerializeCompleted)
    {
        self.status = HTTPMessageSerializeCompleted;
    }
    else if (self.bodySerializer.status == HTTPMessageSerializeError)
    {
        self.status = HTTPMessageSerializeError;
        
        self.error = self.bodySerializer.error;
        
        return nil;
    }
    
    return data;
}

@end
