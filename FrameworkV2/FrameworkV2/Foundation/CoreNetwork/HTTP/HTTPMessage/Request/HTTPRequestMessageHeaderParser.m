//
//  HTTPRequestMessageHeaderParser.m
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestMessageHeaderParser.h"
#import "HTTPMessageError.h"

NSUInteger const HTTPRequestMessageHeaderMaxParseLength = 10 * 1024;

@implementation HTTPRequestMessageHeaderParser

- (void)addData:(NSData *)data
{
    if (data.length == 0)
    {
        return;
    }
    
    [self.buffer appendData:data];
    
    if (self.status == HTTPMessageParsing)
    {
        NSData *headerEndDelimiter = [@"\r\n\r\n" dataUsingEncoding:NSASCIIStringEncoding];
        
        NSRange range = [self.buffer rangeOfData:headerEndDelimiter options:0 range:NSMakeRange(0, self.buffer.length)];
        
        if (range.location != NSNotFound)
        {
            self.status = HTTPMessageParseCompleted;
            
            NSString *method = nil;
            
            NSString *path = nil;
            
            NSString *version = nil;
            
            NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] init];
            
            
            NSData *headerData = [self.buffer subdataWithRange:NSMakeRange(0, range.location)];
            
            NSString *headerString = headerData.length > 0 ? [[NSString alloc] initWithData:headerData encoding:NSASCIIStringEncoding] : nil;
            
            NSArray *components = [headerString componentsSeparatedByString:@"\r\n"];
            
            NSString *line = [components firstObject];
            
            NSArray *lineComponents = [line componentsSeparatedByString:@" "];
            
            for (int i = 0; i < lineComponents.count; i ++)
            {
                if (i == 0)
                {
                    method = [lineComponents objectAtIndex:i];
                }
                else if (i == 1)
                {
                    path = [lineComponents objectAtIndex:i];
                }
                else if (i == 2)
                {
                    version = [lineComponents objectAtIndex:i];
                }
            }
            
            for (int i = 1; i < components.count; i ++)
            {
                NSString *headerFieldString = [components objectAtIndex:i];
                
                NSRange delimiterRange = [headerFieldString rangeOfString:@":"];
                
                if (delimiterRange.location != NSNotFound)
                {
                    NSString *name = [headerFieldString substringToIndex:delimiterRange.location];
                    
                    NSString *value = [headerFieldString substringFromIndex:delimiterRange.location + delimiterRange.length];
                    
                    if ([value containsString:@" "])
                    {
                        value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
                    }
                    
                    if (name && value)
                    {
                        [headerFields setObject:value forKey:name];
                    }
                }
            }
            
            if (method && path && [version containsString:@"HTTP"])
            {
                self.parsedRequestHeader = [[HTTPRequestHeader alloc] init];
                
                self.parsedRequestHeader.version = version;
                
                NSString *host = [headerFields objectForKey:@"Host"];
                
                NSString *urlString = host ? [host stringByAppendingString:path] : path;
                
                self.parsedRequestHeader.URL = [NSURL URLWithString:[@"http://" stringByAppendingString:urlString]];
                
                self.parsedRequestHeader.method = method;
                
                self.parsedRequestHeader.headerFields = headerFields.count > 0 ? headerFields : nil;
            }
            else
            {
                self.status = HTTPMessageParseError;
                
                self.error = [NSError HTTPMessageErrorWithCode:HTTPMessageErrorUnknownRequestHeader];
            }
            
            [self.buffer replaceBytesInRange:NSMakeRange(0, range.location + range.length) withBytes:NULL length:0];
        }
        else if (self.buffer.length > HTTPRequestMessageHeaderMaxParseLength)
        {
            self.status = HTTPMessageParseError;
            
            self.error = [NSError HTTPMessageErrorWithCode:HTTPMessageErrorRequestHeaderExceedLength];
        }
    }
}

- (NSData *)unparsedData
{
    return self.buffer;
}

- (void)cleanUnparsedData
{
    self.buffer.length = 0;
}

@end
