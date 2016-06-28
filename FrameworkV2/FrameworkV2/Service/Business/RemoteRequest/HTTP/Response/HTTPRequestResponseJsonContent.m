//
//  HTTPRequestResponseJsonContent.m
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestResponseJsonContent.h"
#import "NSHTTPURLResponse+ContentValidation.h"

@implementation HTTPRequestResponseJsonContent

- (id)jsonNodeWithError:(NSError *__autoreleasing *)error
{
    *error = self.requestError;
    
    id jsonNode = nil;
    
    if (!self.requestError)
    {
        HTTPResponseValidationCondition *condition = [[HTTPResponseValidationCondition alloc] init];
        
        condition.acceptableStatusCodes = [NSArray arrayWithObject:[NSNumber numberWithInteger:200]];
        
        condition.acceptableMIMETypes = [NSArray arrayWithObjects:@"application/json", @"text/json", @"text/javascript", @"application/javascript", nil];
        
        condition.acceptableStringEncodings = [NSArray arrayWithObject:[NSNumber numberWithInteger:kCFStringEncodingUTF8]];
        
        if ([self.response isContentValidInCondition:condition error:error])
        {
            *error = nil;
            
            jsonNode = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingAllowFragments error:error];
        }
    }
    
    return *error ? nil : jsonNode;
}

@end
