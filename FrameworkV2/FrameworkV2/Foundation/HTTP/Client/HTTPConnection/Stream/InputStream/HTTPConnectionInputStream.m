//
//  HTTPConnectionInputStream.m
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnectionInputStream.h"

@interface HTTPConnectionInputStream () <NSStreamDelegate>
{
    NSStreamStatus _streamStatus;
    
    NSError *_streamError;
    
    __unsafe_unretained id _delegate;
}

@property (nonatomic) NSMutableArray<NSInputStream *> *dataStreams;

@property (nonatomic) NSMutableArray *chunks;

@property (nonatomic) NSMutableDictionary<NSString *, id> *properties;

@property (nonatomic) NSThread *delegateThread;

- (void)operate:(void (^)(void))operation;

- (void)notify:(void (^)(void))notification;

@end


@implementation HTTPConnectionInputStream

@synthesize streamStatus = _streamStatus;

@synthesize streamError = _streamError;

@synthesize delegate = _delegate;

- (void)dealloc
{
    [self close];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.dataStreams = [[NSMutableArray alloc] init];
        
        self.chunks = [[NSMutableArray alloc] init];
        
        self.properties = [[NSMutableDictionary alloc] init];
        
        self.delegate = self;
        
        _streamStatus = NSStreamStatusNotOpen;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    HTTPConnectionInputStream *one = [[HTTPConnectionInputStream alloc] init];
    
    for (HTTPConnectionInputStreamChunk *chunk in self.chunks)
    {
        HTTPConnectionInputStreamChunk *copy = [chunk copy];
        
        [one addChunk:copy];
    }
    
    return one;
}

- (void)setDelegate:(id<NSStreamDelegate>)delegate
{
    _delegate = delegate;
    
    self.delegateThread = [NSThread currentThread];
}

- (void)open
{
    _streamStatus = NSStreamStatusOpen;
    
    for (NSInputStream *stream in self.dataStreams)
    {
        [stream open];
    }
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(stream:handleEvent:)])
        {
            [self.delegate stream:self handleEvent:NSStreamEventOpenCompleted];
        }
        
    }];
}

- (void)close
{
    _streamStatus = NSStreamStatusClosed;
    
    for (NSInputStream *stream in self.dataStreams)
    {
        [stream close];
    }
    
    [self.dataStreams removeAllObjects];
}

- (id)propertyForKey:(NSString *)key
{
    return key ? [self.properties objectForKey:key] : nil;
}

- (BOOL)setProperty:(id)property forKey:(NSString *)key
{
    if (property && key)
    {
        [self.properties setObject:property forKey:key];
    }
    
    return YES;
}

- (void)scheduleInRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
    
}

- (void)removeFromRunLoop:(NSRunLoop *)aRunLoop forMode:(NSString *)mode
{
    
}

// ------ Undocumented CFReadStream Bridged Methods。系统会自动调用这些方法，因为NSURLRequest实际上接受的不是 NSInputStream 对象，而是 CoreFoundation 的 CFReadStreamRef 对象，因为 CFReadStreamRef 和 NSInputStream 是 toll-free bridged，可以自由转换，但CFReadStreamRef 会用到 CFStreamScheduleWithRunLoop 这个方法，当它调用到这个方法时，object-c 的 toll-free bridging 机制会调用 object-c 对象 NSInputStream 的相应函数，这里就调用到了_scheduleInCFRunLoop:forMode:，若不实现这个方法就会crash

- (void)_scheduleInCFRunLoop:(__unused CFRunLoopRef)aRunLoop forMode:(__unused CFStringRef)aMode
{
    
}

- (void)_unscheduleFromCFRunLoop:(__unused CFRunLoopRef)aRunLoop forMode:(__unused CFStringRef)aMode
{
    
}

- (BOOL)_setCFClientFlags:(__unused CFOptionFlags)inFlags callback:(__unused CFReadStreamClientCallBack)inCallback context:(__unused CFStreamClientContext *)inContext
{
    return NO;
}

// ------

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    NSInteger readLength = 0;
    
    while ([self.dataStreams count] > 0 && readLength < len)
    {
        NSInputStream *stream = [self.dataStreams objectAtIndex:0];
        
        NSInteger streamReadLength = [stream read:&buffer[readLength] maxLength:(len - readLength)];
        
        if (streamReadLength > 0)
        {
            readLength += streamReadLength;
        }
        
        if (stream.streamStatus == NSStreamStatusAtEnd)
        {
            [self.dataStreams removeObjectAtIndex:0];
        }
        else if (stream.streamStatus == NSStreamStatusError)
        {
            _streamStatus = NSStreamStatusError;
            
            _streamError = [stream.streamError copy];
            
            break;
        }
    }
    
    if (_streamStatus == NSStreamStatusError)
    {
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(stream:handleEvent:)])
            {
                [self.delegate stream:self handleEvent:NSStreamEventErrorOccurred];
            }
            
        }];
    }
    else if ([self.dataStreams count] == 0)
    {
        _streamStatus = NSStreamStatusAtEnd;
        
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(stream:handleEvent:)])
            {
                [self.delegate stream:self handleEvent:NSStreamEventEndEncountered];
            }
            
        }];
    }
    else
    {
        [self notify:^{
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(stream:handleEvent:)])
            {
                [self.delegate stream:self handleEvent:NSStreamEventHasBytesAvailable];
            }
            
        }];
    }
    
    return readLength;
}

- (BOOL)getBuffer:(uint8_t * _Nullable *)buffer length:(NSUInteger *)len
{
    return NO;
}

- (BOOL)hasBytesAvailable
{
    return [self.dataStreams count] > 0;
}

- (void)addChunk:(HTTPConnectionInputStreamChunk *)chunk
{
    if (chunk)
    {
        NSInputStream *stream = [chunk inputStream];
        
        if (stream)
        {
            [self.chunks addObject:chunk];
            
            [self.dataStreams addObject:stream];
        }
    }
}

- (void)addData:(NSData *)data
{
    if ([data length] > 0)
    {
        HTTPConnectionInputStreamDataChunk *dataChunk = [[HTTPConnectionInputStreamDataChunk alloc] initWithData:data];
        
        [self addChunk:dataChunk];
    }
}

- (void)addFile:(NSString *)filePath
{
    if (filePath)
    {
        HTTPConnectionInputStreamFileChunk *fileChunk = [[HTTPConnectionInputStreamFileChunk alloc] initWithFilePath:filePath];
        
        [self addChunk:fileChunk];
    }
}

- (void)addInputStream:(NSInputStream<NSCopying> *)stream
{
    if (stream)
    {
        HTTPConnectionInputStreamStreamChunk *streamChunk = [[HTTPConnectionInputStreamStreamChunk alloc] initWithStream:stream];
        
        [self addChunk:streamChunk];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
}

- (void)operate:(void (^)(void))operation
{
    if (operation)
    {
        operation();
    }
}

- (void)notify:(void (^)(void))notification
{
    if (self.delegate && self.delegateThread)
    {
        [self performSelector:@selector(operate:) onThread:self.delegateThread withObject:notification waitUntilDone:NO];
    }
}

@end
