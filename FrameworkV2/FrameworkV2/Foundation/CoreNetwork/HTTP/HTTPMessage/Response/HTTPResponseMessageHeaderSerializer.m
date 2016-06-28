//
//  HTTPResponseMessageHeaderSerializer.m
//  HS
//
//  Created by ww on 16/6/1.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPResponseMessageHeaderSerializer.h"

@interface HTTPResponseMessageHeaderSerializer ()

@property (nonatomic) NSMutableData *data;

@end


@implementation HTTPResponseMessageHeaderSerializer

- (instancetype)initWithResponseHeader:(HTTPResponseHeader *)responseHeader
{
    if (self = [super init])
    {
        CFHTTPMessageRef message = CFHTTPMessageCreateResponse(kCFAllocatorDefault, responseHeader.statusCode, (__bridge CFStringRef _Nullable)(responseHeader.statusDescription), (__bridge CFStringRef _Nonnull)(responseHeader.version));
        
        for (NSString *name in [responseHeader.headerFields allKeys])
        {
            NSString *value = [responseHeader.headerFields objectForKey:name];
            
            CFHTTPMessageSetHeaderFieldValue(message, (__bridge CFStringRef _Nonnull)(name), (__bridge CFStringRef _Nullable)(value));
        }
        
        NSData *data = (__bridge NSData *)(CFHTTPMessageCopySerializedMessage(message));
        
        if (data.length > 0)
        {
            self.data = [[NSMutableData alloc] initWithData:data];
        }
        else
        {
            self.status = HTTPMessageSerializeCompleted;
        }
        
        CFRelease(message);
    }
    
    return self;
}

- (NSData *)dataWithMaxLength:(NSUInteger)maxLength
{
    if (maxLength == 0)
    {
        return nil;
    }
    
    NSUInteger length = MIN(self.data.length, maxLength);
    
    NSData *data = [self.data subdataWithRange:NSMakeRange(0, length)];
    
    [self.data replaceBytesInRange:NSMakeRange(0, length) withBytes:NULL length:0];
    
    if (self.data.length == 0)
    {
        self.status = HTTPMessageSerializeCompleted;
    }
    
    return data;
}

@end
