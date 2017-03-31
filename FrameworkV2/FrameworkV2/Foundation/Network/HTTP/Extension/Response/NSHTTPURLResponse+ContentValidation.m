//
//  NSHTTPURLResponse+ContentValidation.m
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSHTTPURLResponse+ContentValidation.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation NSHTTPURLResponse (ContentValidation)

- (BOOL)isContentValidInCondition:(HTTPResponseValidationCondition *)condition error:(NSError *__autoreleasing *)error
{
    NSInteger statusCode = self.statusCode;
    
    NSString *MIMEType = self.MIMEType;
    
    CFStringEncoding stringEncoding = self.textEncodingName ? CFStringConvertIANACharSetNameToEncoding((CFStringRef)self.textEncodingName) : kCFStringEncodingInvalidId;
    
    if (![condition.acceptableStatusCodes containsObject:[NSNumber numberWithInteger:statusCode]])
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        
        [userInfo setObject:[NSString stringWithFormat:@"unacceptable response status code: %ld(%@), url: %@", (long)self.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode], self.URL] forKey:NSLocalizedDescriptionKey];
        
        [userInfo setObject:self.URL ? self.URL : [NSURL URLWithString:@""] forKey:NSURLErrorFailingURLErrorKey];
        
        *error = [NSError errorWithDomain:HTTPResponseContentValidationErrorDomain code:HTTPResponseContentValidationErrorUnacceptableStatusCode userInfo:userInfo];
    }
    else if (!MIMEType || ![condition.acceptableMIMETypes containsObject:MIMEType])
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        
        [userInfo setObject:[NSString stringWithFormat:@"unacceptable response content MIME type: %@, url: %@", self.MIMEType, self.URL] forKey:NSLocalizedDescriptionKey];
        
        [userInfo setObject:self.URL ? self.URL : [NSURL URLWithString:@""] forKey:NSURLErrorFailingURLErrorKey];
        
        *error = [NSError errorWithDomain:HTTPResponseContentValidationErrorDomain code:HTTPResponseContentValidationErrorUnacceptableMIMEType userInfo:userInfo];
    }
    else if (stringEncoding == kCFStringEncodingInvalidId || ![condition.acceptableStringEncodings containsObject:[NSNumber numberWithLongLong:stringEncoding]])
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        
        [userInfo setObject:[NSString stringWithFormat:@"unacceptable response content encoding: %@, url: %@", self.textEncodingName, self.URL] forKey:NSLocalizedDescriptionKey];
        
        [userInfo setObject:self.URL ? self.URL : [NSURL URLWithString:@""] forKey:NSURLErrorFailingURLErrorKey];
        
        *error = [NSError errorWithDomain:HTTPResponseContentValidationErrorDomain code:HTTPResponseContentValidationErrorUnacceptableStringEncoding userInfo:userInfo];
    }
    
    return *error ? NO : YES;
}

@end


@implementation HTTPResponseValidationCondition

@end


NSString * const HTTPResponseContentValidationErrorDomain = @"HTTPResponseContentValidation";
