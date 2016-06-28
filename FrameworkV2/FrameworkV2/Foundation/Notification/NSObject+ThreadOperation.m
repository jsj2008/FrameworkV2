//
//  NSObject+ThreadOperation.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSObject+ThreadOperation.h"

@implementation NSObject (ThreadOperation)

- (void)operate:(void (^)(void))operation onThread:(NSThread *)thread
{
    if (thread && [thread isExecuting])
    {
        [self performSelector:@selector(operate:) onThread:thread withObject:operation waitUntilDone:NO];
    }
    else
    {
        if (operation)
        {
            operation();
        }
    }
}

- (void)operate:(void (^)(void))operation
{
    if (operation)
    {
        operation();
    }
}

@end
