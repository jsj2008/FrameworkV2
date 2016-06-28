//
//  HTTPMessageParser.m
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageParser.h"

@interface HTTPMessageParser ()
{
    NSMutableData *_buffer;
}

@end


@implementation HTTPMessageParser

@synthesize buffer = _buffer;

- (instancetype)init
{
    if (self = [super init])
    {
        self.status = HTTPMessageParsing;
        
        _buffer = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    
}

- (NSData *)unparsedData
{
    return nil;
}

- (void)cleanUnparsedData
{
    
}

@end
