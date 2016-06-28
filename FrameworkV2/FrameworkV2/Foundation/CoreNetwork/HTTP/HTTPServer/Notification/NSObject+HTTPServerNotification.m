//
//  NSObject+HTTPServerNotification.m
//  HS
//
//  Created by ww on 16/5/24.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSObject+HTTPServerNotification.h"

@implementation NSObject (HTTPServerNotification)

- (void)HTTPServerNotify:(void (^)(void))notification onThread:(NSThread *)thread
{
    if (thread && [thread isExecuting])
    {
        [self performSelector:@selector(HTTPServerNotify:) onThread:thread withObject:notification waitUntilDone:NO];
    }
    else
    {
        if (notification)
        {
            notification();
        }
    }
}

- (void)HTTPServerNotify:(void (^)(void))notification
{
    if (notification)
    {
        notification();
    }
}

@end
