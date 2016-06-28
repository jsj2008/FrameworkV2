//
//  TCPServerConnection.m
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "TCPServerConnection.h"
#import <sys/socket.h>
#import <arpa/inet.h>

@interface TCPServerConnection ()
{
    // Socket句柄
    CFSocketNativeHandle _socketNativeHandle;
    
    // 数据接收流
    NSInputStream *_receivingStream;
    
    // 数据发送流
    NSOutputStream *_sendingStream;
    
    // 客户端地址
    NSString *_address;
    
    // 服务端数据通讯端口
    NSInteger _port;
}

/*!
 * @brief 解析Socket句柄
 * @param address 客户端地址
 * @param port 服务端数据通讯端口
 * @param handle Socket句柄
 */
- (void)socketInfoWithAddress:(NSString **)address port:(NSInteger *)port fromNativeHandle:(CFSocketNativeHandle)handle;

@end


@implementation TCPServerConnection

@synthesize socketNativeHandle = _socketNativeHandle;

@synthesize receivingStream = _receivingStream;

@synthesize sendingStream = _sendingStream;

- (id)initWithSocketNativeHandle:(CFSocketNativeHandle)socketNativeHandle
{
    if (self = [super init])
    {
        _socketNativeHandle = socketNativeHandle;
        
        NSString *address = nil;
        
        [self socketInfoWithAddress:&address port:&_port fromNativeHandle:_socketNativeHandle];
        
        _address = address;
        
        CFReadStreamRef readStream;
        
        CFWriteStreamRef writeStream;
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, _socketNativeHandle, &readStream, &writeStream);
        
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        _receivingStream = (__bridge_transfer NSInputStream *)(readStream);
        
        _sendingStream = (__bridge_transfer NSOutputStream *)writeStream;
    }
    
    return self;
}

- (void)socketInfoWithAddress:(NSString **)address port:(NSInteger *)port fromNativeHandle:(CFSocketNativeHandle)handle
{
    if (_socketNativeHandle != -1)
    {
        uint8_t name[SOCK_MAXADDRLEN];
        
        socklen_t namelen = sizeof(name);
        
        NSData *peer = nil;
        
        if (0 == getpeername(_socketNativeHandle, (struct sockaddr *)name, &namelen))
        {
            peer = [NSData dataWithBytes:name length:namelen];
        }
        
        if (peer)
        {
            // ipv4 length = 16； ipv6 length = 28
            if ([peer length] < 20)
            {
                struct sockaddr_in add4;
                
                memcpy(&add4, [peer bytes], [peer length]);
                
                unsigned char *p = (unsigned char *)&(add4.sin_addr.s_addr);
                
                *address = [NSString stringWithFormat:@"%d.%d.%d.%d", p[0], p[1], p[2], p[3]];
                
                *port = ntohs(add4.sin_port);
            }
            else
            {
                struct sockaddr_in6 add6;
                
                char addressChar[16];
                
                memcpy(&add6, [peer bytes], [peer length]);
                
                if (inet_ntop(AF_INET6, &add6, addressChar, sizeof(addressChar)/sizeof(char)))
                {
                    *address = [NSString stringWithCString:addressChar encoding:NSUTF8StringEncoding];
                    
                    *port = ntohs(add6.sin6_port);
                }
                else
                {
                    *address = nil;
                    
                    *port = 0;
                }
            }
        }
    }
}

- (NSString *)socketAddress
{
    return [_address copy];
}

- (NSUInteger)socketPort
{
    return _port;
}

@end
