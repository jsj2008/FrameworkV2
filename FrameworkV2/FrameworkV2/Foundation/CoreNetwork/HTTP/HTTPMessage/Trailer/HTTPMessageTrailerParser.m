//
//  HTTPMessageTrailerParser.m
//  HS
//
//  Created by ww on 16/5/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPMessageTrailerParser.h"
#import "HTTPMessageError.h"

NSUInteger const HTTPMessageTrailerMaxParseLength = 10 * 1024;


@interface HTTPMessageTrailerParser ()
{
    NSArray<NSString *> *_headerFieldNames;
}

@property (nonatomic) NSMutableArray *headerFieldStrings;

@property (nonatomic) NSUInteger parsedLength;

@end


@implementation HTTPMessageTrailerParser

- (instancetype)initWithHeaderFieldNames:(NSArray<NSString *> *)headerFieldNames
{
    if (self = [super init])
    {
        _headerFieldNames = [headerFieldNames copy];
        
        self.headerFieldStrings = [[NSMutableArray alloc] init];
        
        if (_headerFieldNames.count == 0)
        {
            self.status = HTTPMessageParseCompleted;
        }
    }
    
    return self;
}

- (void)addData:(NSData *)data
{
    if (data.length == 0)
    {
        return;
    }
    
    [self.buffer appendData:data];
    
    NSData *CRLFData = [@"\r\n" dataUsingEncoding:NSASCIIStringEncoding];
    
    while (self.headerFieldStrings.count < self.headerFieldNames.count)
    {
        NSRange range = [self.buffer rangeOfData:CRLFData options:0 range:NSMakeRange(0, self.buffer.length)];
        
        if (range.location != NSNotFound)
        {
            NSData *headerFieldData = [self.buffer subdataWithRange:NSMakeRange(0, range.location)];
            
            NSString *headerFieldString = [[NSString alloc] initWithData:headerFieldData encoding:NSASCIIStringEncoding];
            
            [self.headerFieldStrings addObject:headerFieldString ? headerFieldString : @""];
            
            [self.buffer replaceBytesInRange:NSMakeRange(0, range.location + range.length) withBytes:NULL length:0];
            
            self.parsedLength += range.location + range.length;
        }
        else
        {
            break;
        }
    }
    
    if (self.headerFieldStrings.count == self.headerFieldNames.count)
    {
        NSMutableDictionary *headerFields = [[NSMutableDictionary alloc] init];
        
        for (NSString *headerFieldString in self.headerFieldStrings)
        {
            NSRange range = [headerFieldString rangeOfString:@":"];
            
            if (range.location != NSNotFound)
            {
                NSString *name = [headerFieldString substringToIndex:range.location];
                
                NSString *value = [headerFieldString substringFromIndex:(range.location + range.length)];
                
                value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if (name && [self.headerFieldNames containsObject:name])
                {
                    [headerFields setObject:(value ? value : nil) forKey:name];
                }
            }
        }
        
        if (headerFields.count == self.headerFieldNames.count)
        {
            HTTPTrailer *trailer = [[HTTPTrailer alloc] init];
            
            trailer.headerFields = headerFields;
            
            self.parsedTrailer = trailer;
            
            self.status = HTTPMessageParseCompleted;
        }
        else
        {
            self.status = HTTPMessageParseError;
            
            self.error = [NSError HTTPMessageErrorWithCode:HTTPMessageErrorUnknownTrailer];
        }
    }
    else if (self.parsedLength + self.buffer.length > HTTPMessageTrailerMaxParseLength)
    {
        self.status = HTTPMessageParseError;
        
        self.error = [NSError HTTPMessageErrorWithCode:HTTPMessageErrorUnknownTrailer];
    }
    
}

@end
