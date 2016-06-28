//
//  TCPServerListener.m
//  HTTPServer
//
//  Created by WW on 13-8-27.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "TCPServerListener.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#import "TCPServerError.h"

@interface TCPServerListener ()
{
    NSError *_error;
}

@property (nonatomic) CFSocketRef IPv4Socket;

@property (nonatomic) CFSocketRef IPv6Socket;

/*!
 * @brief 释放服务端socket
 * @discussion 在这里彻底释放socket资源
 * @param socketRef 服务端socket
 */
- (void)releaseSocket:(CFSocketRef)socketRef;

/*!
 * @brief 接收客户端socket句柄
 * @param handle 客户端socket句柄
 */
- (void)acceptNativeHandle:(CFSocketNativeHandle)handle;

@end


static void SocketAcceptCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    if (type == kCFSocketAcceptCallBack)
    {
        CFSocketNativeHandle handle = *((CFSocketNativeHandle *)data);
        
        if (handle != -1)
        {
            TCPServerListener *socket = (__bridge TCPServerListener *)info;
            
            [socket acceptNativeHandle:handle];
        }
        else
        {
            close(handle);
        }
    }
}


@implementation TCPServerListener

@synthesize error = _error;

- (void)dealloc
{
    [self cancel];
}

- (id)initWithPort:(NSInteger)port
{
    if (self = [super init])
    {
        if (!self.error)
        {
            struct sockaddr_in address4;
            
            address4.sin_len = sizeof(struct sockaddr_in);
            
            address4.sin_family = AF_INET;
            
            address4.sin_port = htons(port);
            
            address4.sin_addr.s_addr = htonl(INADDR_ANY);
            
            memset(&(address4.sin_zero), 0, sizeof(address4.sin_zero));
            
            CFSocketContext context4 = {0, (__bridge void *)(self), NULL, NULL, NULL};
            
            self.IPv4Socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, &SocketAcceptCallBack, &context4);
            
            CFDataRef address4Data = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&address4, sizeof(address4));
            
            CFSocketError socketError = CFSocketSetAddress(self.IPv4Socket, address4Data);
            
            if (socketError != kCFSocketSuccess)
            {
                [self releaseSocket:self.IPv4Socket];
                
                self.IPv4Socket = nil;
                
                _error = [NSError TCPServerErrorWithCode:TCPServerErrorIPv4SocketError];
            }
            
            CFRelease(address4Data);
        }
        
        if (!self.error)
        {
            struct sockaddr_in6 address6;
            
            address6.sin6_len = sizeof(struct sockaddr_in6);
            
            address6.sin6_family = AF_INET6;
            
            address6.sin6_port = htons(port);
            
            address6.sin6_flowinfo = 0;
            
            address6.sin6_addr = in6addr_any;
            
            address6.sin6_scope_id = 0;
            
            CFSocketContext context6 = {0, (__bridge void *)(self), NULL, NULL, NULL};
            
            self.IPv6Socket = CFSocketCreate(kCFAllocatorDefault, AF_INET6, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, &SocketAcceptCallBack, &context6);
            
            CFDataRef address6Data = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&address6, sizeof(address6));
            
            CFSocketError socketError = CFSocketSetAddress(self.IPv6Socket, address6Data);
            
            if (socketError != kCFSocketSuccess)
            {
                [self releaseSocket:self.IPv6Socket];
                
                self.IPv6Socket = nil;
                
                _error = [NSError TCPServerErrorWithCode:TCPServerErrorIPv6SocketError];
            }
            
            CFRelease(address6Data);
        }
    }
    
    return self;
}

- (void)releaseSocket:(CFSocketRef)socketRef
{
    if (socketRef)
    {
        CFSocketInvalidate(socketRef);
        
        CFRelease(socketRef);
    }
}

- (void)start
{
    if (self.IPv4Socket)
    {
        BOOL value = YES;
        
        setsockopt(CFSocketGetNative(self.IPv4Socket), SOL_SOCKET, SO_REUSEADDR, &value, sizeof(value));
        
        CFRunLoopSourceRef socketSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, self.IPv4Socket, 0);
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), socketSource, kCFRunLoopDefaultMode);
        
        CFRelease(socketSource);
    }
    
    if (self.IPv6Socket)
    {
        BOOL value = YES;
        
        setsockopt(CFSocketGetNative(self.IPv6Socket), SOL_SOCKET, SO_REUSEADDR, &value, sizeof(value));
        
        CFRunLoopSourceRef socketSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, self.IPv6Socket, 0);
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), socketSource, kCFRunLoopDefaultMode);
        
        CFRelease(socketSource);
    }
}

- (void)cancel
{
    [self releaseSocket:self.IPv4Socket];
    
    self.IPv4Socket = nil;
    
    [self releaseSocket:self.IPv6Socket];
    
    self.IPv6Socket = nil;
}

- (void)acceptNativeHandle:(CFSocketNativeHandle)handle
{
    if (handle != -1)
    {
        TCPServerConnection *connection = [[TCPServerConnection alloc] initWithSocketNativeHandle:handle];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(TCPServerListener:didAcceptConnection:)])
        {
            [self.delegate TCPServerListener:self didAcceptConnection:connection];
        }
    }
}

- (NSInteger)currentIPv4Port
{
    NSInteger port = 0;
    
    if (self.IPv4Socket)
    {
        CFDataRef address4Data = CFSocketCopyAddress(self.IPv4Socket);
        
        struct sockaddr_in *pSockAddr = (struct sockaddr_in *)CFDataGetBytePtr(address4Data);
        
        port = ntohs(pSockAddr->sin_port);
        
        CFRelease(address4Data);
    }
    
    return port;
}

- (NSInteger)currentIPv6Port
{
    NSInteger port = 0;
    
    if (self.IPv6Socket)
    {
        CFDataRef address6Data = CFSocketCopyAddress(self.IPv6Socket);
        
        struct sockaddr_in6 *pSockAddr = (struct sockaddr_in6 *)CFDataGetBytePtr(address6Data);
        
        port = ntohs(pSockAddr->sin6_port);
        
        CFRelease(address6Data);
    }
    
    return port;
}

@end
