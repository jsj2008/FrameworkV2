//
//  HTTPMessageSerializer.m
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageSerializer.h"

@implementation HTTPMessageSerializer

- (instancetype)init
{
    if (self = [super init])
    {
        self.status = HTTPMessageSerializing;
    }
    
    return self;
}

- (NSData *)dataWithMaxLength:(NSUInteger)maxLength
{
    return nil;
}

@end
