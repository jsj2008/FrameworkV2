//
//  HTTPRequestMessageParser.m
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestMessageParser.h"
#import "HTTPRequestMessageHeaderParser.h"
#import "HTTPMessageBodyParser.h"
#import "HTTPMessageTrailerParser.h"
#import "HTTPMessageError.h"

typedef NS_ENUM(NSUInteger, HTTPServerRequestMessageParseStauts)
{
    HTTPServerRequestMessageParseStauts_Header = 1,
    HTTPServerRequestMessageParseStauts_Body = 2,
    HTTPServerRequestMessageParseStauts_Trailer = 3,
    HTTPServerRequestMessageParseStauts_Completed = 4
};


@interface HTTPRequestMessageParser ()
{
    NSMutableArray *_parsedChunks;
}

@property (nonatomic) HTTPServerRequestMessageParseStauts messageStatus;

@property (nonatomic) HTTPRequestMessageHeaderParser *headerParser;

@property (nonatomic) HTTPMessageBodyParser *bodyParser;

@property (nonatomic) HTTPMessageTrailerParser *trailerParser;

@end


@implementation HTTPRequestMessageParser

@synthesize parsedChunks = _parsedChunks;

- (instancetype)init
{
    if (self = [super init])
    {
        _parsedChunks = [[NSMutableArray alloc] init];
        
        self.messageStatus = HTTPServerRequestMessageParseStauts_Header;
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
    
    if (self.messageStatus == HTTPServerRequestMessageParseStauts_Header)
    {
        if (!self.headerParser)
        {
            self.headerParser = [[HTTPRequestMessageHeaderParser alloc] init];
        }
        
        if (self.headerParser.status == HTTPMessageParsing)
        {
            [self.headerParser addData:self.buffer];
            
            self.buffer.length = 0;
        }
        
        if (self.headerParser.status == HTTPMessageParsing)
        {
            ;
        }
        else if (self.headerParser.status == HTTPMessageParseCompleted)
        {
            self.messageStatus = HTTPServerRequestMessageParseStauts_Body;
            
            NSData *unparsedData = [self.headerParser unparsedData];
            
            if (unparsedData.length > 0)
            {
                [self.buffer appendData:unparsedData];
                
                [self.headerParser cleanUnparsedData];
            }
            
            HTTPRequestHeader *header = self.headerParser.parsedRequestHeader;
            
            NSDictionary *headerFields = header.headerFields;
            
            NSString *contentLengthValue = [headerFields objectForKey:@"Content-Length"];
            
            NSString *transferEncodingValue = [headerFields objectForKey:@"Transfer-Encoding"];
            
            if (contentLengthValue)
            {
                self.bodyParser = [[HTTPMessageLengthFixedBodyParser alloc] initWithLength:contentLengthValue.longLongValue];
            }
            else if ([transferEncodingValue isEqualToString:@"chunked"])
            {
                self.bodyParser = [[HTTPMessageChunkedBodyParser alloc] init];
            }
            
            HTTPRequestMessageParsedHeaderChunk *chunk = [[HTTPRequestMessageParsedHeaderChunk alloc] init];
            
            chunk.requestHeader = header;
            
            [self.parsedChunks addObject:chunk];
        }
        else if (self.headerParser.status == HTTPMessageParseError)
        {
            self.messageStatus = HTTPServerRequestMessageParseStauts_Completed;
            
            self.status = HTTPMessageParseError;
            
            self.error = self.headerParser.error;
            
            return;
        }
    }
    
    if (self.messageStatus == HTTPServerRequestMessageParseStauts_Body)
    {
        if (self.bodyParser)
        {
            if (self.bodyParser.status == HTTPMessageParsing)
            {
                [self.bodyParser addData:self.buffer];
                
                self.buffer.length = 0;
            }
            
            if (self.bodyParser.status == HTTPMessageParsing)
            {
                if (self.bodyParser.parsedBodyData.length > 0)
                {
                    HTTPRequestMessageParsedBodyDataChunk *chunk = [[HTTPRequestMessageParsedBodyDataChunk alloc] init];
                    
                    chunk.bodyData = [self.bodyParser.parsedBodyData copy];
                    
                    [self.parsedChunks addObject:chunk];
                    
                    self.bodyParser.parsedBodyData.length = 0;
                }
            }
            else if (self.bodyParser.status == HTTPMessageParseCompleted)
            {
                self.messageStatus = HTTPServerRequestMessageParseStauts_Trailer;
                
                if (self.bodyParser.parsedBodyData.length > 0)
                {
                    HTTPRequestMessageParsedBodyDataChunk *chunk = [[HTTPRequestMessageParsedBodyDataChunk alloc] init];
                    
                    chunk.bodyData = [self.bodyParser.parsedBodyData copy];
                    
                    [self.parsedChunks addObject:chunk];
                    
                    self.bodyParser.parsedBodyData.length = 0;
                }
                
                NSData *unparsedData = [self.bodyParser unparsedData];
                
                if (unparsedData.length > 0)
                {
                    [self.buffer appendData:unparsedData];
                    
                    [self.bodyParser cleanUnparsedData];
                }
                
                NSString *trailerValue = [self.headerParser.parsedRequestHeader.headerFields objectForKey:@"Trailer"];
                
                trailerValue = [trailerValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                self.trailerParser = [[HTTPMessageTrailerParser alloc] initWithHeaderFieldNames:[trailerValue componentsSeparatedByString:@";"]];
            }
            else if (self.bodyParser.status == HTTPMessageParseError)
            {
                self.messageStatus = HTTPServerRequestMessageParseStauts_Completed;
                
                self.status = HTTPMessageParseError;
                
                self.error = self.bodyParser.error;
            }
        }
        else
        {
            self.messageStatus = HTTPServerRequestMessageParseStauts_Trailer;
        }
    }
    
    if (self.messageStatus == HTTPServerRequestMessageParseStauts_Trailer)
    {
        if (self.trailerParser.status == HTTPMessageParsing)
        {
            [self.trailerParser addData:self.buffer];
            
            self.buffer.length = 0;
        }
        
        if (self.trailerParser.status == HTTPMessageParsing)
        {
            ;
        }
        else if (self.trailerParser.status == HTTPMessageParseCompleted)
        {
            NSData *unparsedData = [self.trailerParser unparsedData];
            
            if (unparsedData.length > 0)
            {
                [self.buffer appendData:unparsedData];
                
                [self.trailerParser cleanUnparsedData];
            }
            
            HTTPRequestMessageParsedTrailerChunk *chunk = [[HTTPRequestMessageParsedTrailerChunk alloc] init];
            
            chunk.trailer = self.trailerParser.parsedTrailer;
            
            [self.parsedChunks addObject:chunk];
            
            self.messageStatus = HTTPServerRequestMessageParseStauts_Completed;
        }
        else if (self.trailerParser.status == HTTPMessageParseError)
        {
            self.status = HTTPMessageParseError;
            
            self.error = self.trailerParser.error;
        }
    }
    
    if (self.messageStatus == HTTPServerRequestMessageParseStauts_Completed)
    {
        self.status = HTTPMessageParseCompleted;
    }
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


@implementation HTTPRequestMessageParsedChunk

@end


@implementation HTTPRequestMessageParsedHeaderChunk

@end


@implementation HTTPRequestMessageParsedBodyDataChunk

@end


@implementation HTTPRequestMessageParsedTrailerChunk

@end
