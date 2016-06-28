//
//  TCPServerIPAddress.m
//  HS
//
//  Created by ww on 16/6/2.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "TCPServerIPAddress.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation TCPServerIPAddress

@end


@implementation TCPServerIPAddress (System)

+ (NSDictionary<NSString *,TCPServerIPAddress *> *)systemIPAddresses
{
    NSMutableDictionary *addresses = [[NSMutableDictionary alloc] init];
    
    struct ifaddrs *interfaces;
    
    if(!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        
        for(interface=interfaces; interface; interface=interface->ifa_next)
        {            
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ )
            {
                continue; // deeply nested code harder to read
            }
            
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];
            
            if(addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6))
            {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                
                if (!name)
                {
                    name = @"";
                }
                
                TCPServerIPAddress *address = [addresses objectForKey:name];
                
                if (!address)
                {
                    address = [[TCPServerIPAddress alloc] init];
                    
                    address.name = name;
                    
                    [addresses setObject:address forKey:name];
                }
                
                if(addr->sin_family == AF_INET)
                {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN))
                    {
                        address.IPv4Address = [NSString stringWithUTF8String:addrBuf];
                    }
                }
                else
                {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN))
                    {
                        address.IPv6Address = [NSString stringWithUTF8String:addrBuf];
                    }
                }
            }
        }
        
        freeifaddrs(interfaces);
    }
    
    return addresses;
}

@end
