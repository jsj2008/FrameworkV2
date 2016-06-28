//
//  HTTPServerListener.m
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPServerListener.h"
#import "TCPServerListener.h"

@interface HTTPServerListener () <TCPServerListenerDelegate>

@property (nonatomic) TCPServerListener *TCPListener;

@end


@implementation HTTPServerListener

- (id)initWithPort:(NSInteger)port
{
    if (self = [super init])
    {
        self.TCPListener = [[TCPServerListener alloc] initWithPort:port];
        
        self.TCPListener.delegate = self;
    }
    
    return self;
}

- (NSInteger)currentIPv4Port
{
    return self.TCPListener.currentIPv4Port;
}

- (NSInteger)currentIPv6Port
{
    return self.TCPListener.currentIPv6Port;
}

- (NSError *)error
{
    return self.TCPListener.error;
}

- (void)start
{
    [self.TCPListener start];
}

- (void)cancel
{
    [self.TCPListener cancel];
}

- (void)TCPServerListener:(TCPServerListener *)listener didAcceptConnection:(TCPServerConnection *)connection
{
    HTTPServerConnection *httpConnection = [[HTTPServerConnection alloc] initWithTCPServerConnection:connection];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HTTPServerListener:didAcceptConnection:)])
    {
        [self.delegate HTTPServerListener:self didAcceptConnection:httpConnection];
    }
}

@end
