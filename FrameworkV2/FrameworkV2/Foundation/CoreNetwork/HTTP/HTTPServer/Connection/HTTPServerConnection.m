//
//  HTTPServerConnection.m
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPServerConnection.h"
#import "HTTPRequestMessageParser.h"
#import "HTTPResponseMessageSerializer.h"
#import "HTTPServerError.h"
#import "NSObject+HTTPServerNotification.h"

@interface HTTPServerConnection () <NSStreamDelegate>
{
    TCPServerConnection *_TCPConnection;
}

@property (nonatomic) HTTPRequestMessageParser *requestParser;

@property (nonatomic) HTTPResponseMessageSerializer *responseSerializer;

@property (nonatomic) NSInputStream *receivingStream;

@property (nonatomic) NSOutputStream *sendingStream;

@property (nonatomic) NSRunLoop *streamRunLoop;

@property (nonatomic) NSThread *notifyThread;

- (void)finishWithError:(NSError *)error;

- (void)closeStream:(NSStream *)stream;

- (void)receiveData;

- (void)sendData;

@end


@implementation HTTPServerConnection

@synthesize TCPConnection = _TCPConnection;

- (void)dealloc
{
    [self cancel];
}

- (instancetype)initWithTCPServerConnection:(TCPServerConnection *)TCPConnection
{
    if (self = [super init])
    {
        _TCPConnection = TCPConnection;
        
        self.receivingStream = TCPConnection.receivingStream;
        
        self.sendingStream = TCPConnection.sendingStream;
    }
    
    return self;
}

- (void)start
{
    self.notifyThread = [NSThread currentThread];
    
    [self.receivingStream open];
    
    [self.sendingStream open];
    
    if (self.receivingStream.streamStatus == NSStreamStatusError)
    {
        [self finishWithError:self.receivingStream.streamError];
    }
    else if (self.sendingStream.streamStatus == NSStreamStatusError)
    {
        [self finishWithError:self.sendingStream.streamError];
    }
    else
    {
        self.streamRunLoop = [NSRunLoop currentRunLoop];
        
        self.receivingStream.delegate = self;
        
        [self.receivingStream scheduleInRunLoop:self.streamRunLoop forMode:NSDefaultRunLoopMode];
        
        self.sendingStream.delegate = self;
        
        [self.sendingStream scheduleInRunLoop:self.streamRunLoop forMode:NSDefaultRunLoopMode];
        
        self.requestParser = [[HTTPRequestMessageParser alloc] init];
    }
}

- (void)cancel
{
    [self closeStream:self.receivingStream];
    
    [self closeStream:self.sendingStream];
}

- (void)closeStream:(NSStream *)stream
{
    stream.delegate = nil;
    
    if (self.streamRunLoop)
    {
        [stream removeFromRunLoop:self.streamRunLoop forMode:NSDefaultRunLoopMode];
    }
    
    [stream close];
    
    if (stream == self.receivingStream)
    {
        self.receivingStream = nil;
    }
    
    if (stream == self.sendingStream)
    {
        self.sendingStream = nil;
    }
}

- (void)closeReceiving
{
    [self closeStream:self.receivingStream];
}

- (void)closeSending
{
    [self closeStream:self.sendingStream];
}

- (void)finishWithError:(NSError *)error
{
    [self cancel];
    
    [self HTTPServerNotify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didFinishWithError:)])
        {
            [self.delegate HTTPServerConnection:self didFinishWithError:error];
        }
        
    } onThread:self.notifyThread];
}

- (void)sendResponse:(HTTPResponseHeader *)response
{
    self.responseSerializer = [[HTTPResponseMessageSerializer alloc] initWithResponseHeader:response];
    
    [self sendData];
}

- (void)sendResponse:(HTTPResponseHeader *)response bodyData:(NSData *)bodyData
{
    self.responseSerializer = [[HTTPResponseMessageSerializer alloc] initWithResponseHeader:response bodyData:bodyData];
    
    [self sendData];
}

- (void)sendResponse:(HTTPResponseHeader *)response bodyStream:(NSInputStream *)bodyStream
{
    self.responseSerializer = [[HTTPResponseMessageSerializer alloc] initWithResponseHeader:response bodyStream:bodyStream];
    
    [self sendData];
}

- (void)receiveData
{
    if (self.receivingStream && self.requestParser)
    {
        if (self.requestParser.status == HTTPMessageParsing)
        {
            uint8_t buffer[1024];
            
            NSInteger length = [self.receivingStream read:buffer maxLength:1024];
            
            if (length > 0)
            {
                [self.requestParser addData:[NSData dataWithBytes:buffer length:length]];
            }
        }
        
        if (self.requestParser.status == HTTPMessageParsing || self.requestParser.status == HTTPMessageParseCompleted)
        {
            for (HTTPRequestMessageParsedChunk *chunk in self.requestParser.parsedChunks)
            {
                if ([chunk isKindOfClass:[HTTPRequestMessageParsedHeaderChunk class]])
                {
                    [self HTTPServerNotify:^{
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didReceiveRequest:)])
                        {
                            [self.delegate HTTPServerConnection:self didReceiveRequest:((HTTPRequestMessageParsedHeaderChunk *)chunk).requestHeader];
                        }
                        
                    } onThread:self.notifyThread];
                }
                else if ([chunk isKindOfClass:[HTTPRequestMessageParsedBodyDataChunk class]])
                {
                    [self HTTPServerNotify:^{
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didReceiveData:)])
                        {
                            [self.delegate HTTPServerConnection:self didReceiveData:((HTTPRequestMessageParsedBodyDataChunk *)chunk).bodyData];
                        }
                        
                    } onThread:self.notifyThread];
                }
                else if ([chunk isKindOfClass:[HTTPRequestMessageParsedTrailerChunk class]])
                {
                    [self HTTPServerNotify:^{
                        
                        if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didReceiveTrailer:)])
                        {
                            [self.delegate HTTPServerConnection:self didReceiveTrailer:((HTTPRequestMessageParsedTrailerChunk *)chunk).trailer];
                        }
                        
                    } onThread:self.notifyThread];
                }
            }
            
            [self.requestParser.parsedChunks removeAllObjects];
        }
        
        if (self.requestParser.status == HTTPMessageParseCompleted)
        {
            [self closeStream:self.receivingStream];
            
            [self HTTPServerNotify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didFinishReceiveDataWithError:)])
                {
                    [self.delegate HTTPServerConnection:self didFinishReceiveDataWithError:nil];
                }
                
            } onThread:self.notifyThread];
            
            self.requestParser = nil;
        }
        else if (self.requestParser.status == HTTPMessageParseError)
        {
            [self closeStream:self.receivingStream];
            
            NSError *error = [NSError HTTPServerErrorWithCode:HTTPServerErrorCannotParseRequestMessage underlyingError:self.requestParser.error];
            
            [self HTTPServerNotify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didFinishReceiveDataWithError:)])
                {
                    [self.delegate HTTPServerConnection:self didFinishReceiveDataWithError:error];
                }
                
            } onThread:self.notifyThread];
            
            self.requestParser = nil;
        }
        else if (self.requestParser.status == HTTPMessageParsing && self.receivingStream.streamStatus == NSStreamStatusAtEnd)
        {
            [self closeStream:self.receivingStream];
            
            NSError *error = [NSError HTTPServerErrorWithCode:HTTPServerErrorCannotParseRequestMessage underlyingError:nil];
            
            [self HTTPServerNotify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didFinishReceiveDataWithError:)])
                {
                    [self.delegate HTTPServerConnection:self didFinishReceiveDataWithError:error];
                }
                
            } onThread:self.notifyThread];
            
            self.requestParser = nil;
        }
    }
}

- (void)sendData
{
    if (self.sendingStream && self.responseSerializer)
    {
        NSData *data = nil;
        
        if (self.responseSerializer.status == HTTPMessageSerializing)
        {
            data = [self.responseSerializer dataWithMaxLength:4 * 1024];
        }
        
        if (self.responseSerializer.status == HTTPMessageSerializing || self.responseSerializer.status == HTTPMessageSerializeCompleted)
        {
            if (data.length > 0)
            {
                [self.sendingStream write:data.bytes maxLength:data.length];
                
                unsigned long long sentDataSize = self.responseSerializer.consumedBodySizeInLastRead;
                
                unsigned long long totalBytesWritten = self.responseSerializer.consumedBodySize;
                
                long long totalBytesExpectedToWrite = self.responseSerializer.bodySize;
                
                [self HTTPServerNotify:^{
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didSendData:totalBytesWritten:totalBytesExpectedToWrite:)])
                    {
                        [self.delegate HTTPServerConnection:self didSendData:sentDataSize totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
                    }
                    
                } onThread:self.notifyThread];
            }
        }
        
        if (self.responseSerializer.status == HTTPMessageSerializeCompleted)
        {
            [self HTTPServerNotify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didFinishSendDataWithError:)])
                {
                    [self.delegate HTTPServerConnection:self didFinishSendDataWithError:nil];
                }
                
            } onThread:self.notifyThread];
            
            self.responseSerializer = nil;
        }
        else if (self.responseSerializer.status == HTTPMessageSerializeError)
        {
            NSError *error = [NSError HTTPServerErrorWithCode:HTTPServerErrorCannotSerializeResponseMessage underlyingError:self.responseSerializer.error];
            
            [self HTTPServerNotify:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerConnection:didFinishSendDataWithError:)])
                {
                    [self.delegate HTTPServerConnection:self didFinishSendDataWithError:error];
                }
                
            } onThread:self.notifyThread];
            
            self.responseSerializer = nil;
        }
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventHasSpaceAvailable:
        {
            if (aStream == self.sendingStream)
            {
                [self sendData];
            }
            
            break;
        }
        case NSStreamEventHasBytesAvailable:
        {
            if (aStream == self.receivingStream)
            {
                [self receiveData];
            }
            
            break;
        }
        case NSStreamEventEndEncountered:
        {
            [self receiveData];
            
            [self closeStream:aStream];
            
            if (!self.receivingStream && !self.sendingStream)
            {
                [self finishWithError:nil];
            }
            
            break;
        }
        case NSStreamEventErrorOccurred:
        {
            if (aStream == self.receivingStream)
            {
                NSError *error = [NSError HTTPServerErrorWithCode:HTTPServerErrorConnectionInputError underlyingError:aStream.streamError];
                
                [self closeStream:aStream];
                
                if (!self.receivingStream && !self.sendingStream)
                {
                    [self finishWithError:error];
                }
            }
            else if (aStream == self.sendingStream)
            {
                NSError *error = [NSError HTTPServerErrorWithCode:HTTPServerErrorConnectionOutputError underlyingError:aStream.streamError];
                
                [self closeStream:aStream];
                
                if (!self.receivingStream && !self.sendingStream)
                {
                    [self finishWithError:error];
                }
            }
            
            break;
        }
        default:
            break;
    }
}

@end
