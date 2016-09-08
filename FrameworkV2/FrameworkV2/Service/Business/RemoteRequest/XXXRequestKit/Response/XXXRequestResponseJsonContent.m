//
//  XXXRequestResponseJsonContent.m
//  FrameworkV2
//
//  Created by ww on 16/7/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "XXXRequestResponseJsonContent.h"
#import "XXXRequestError.h"

@implementation XXXRequestResponseJsonContent

- (NSDictionary *)dataNodeWithError:(NSError *__autoreleasing *)error
{
    NSDictionary *dataNode = nil;
    
    id jsonNode = [self jsonNodeWithError:error];
    
    if (*error)
    {
        ;
    }
    else
    {
        if (jsonNode && ![jsonNode isKindOfClass:[NSDictionary class]])
        {
            *error = [NSError XXXRequestErrorWithCode:XXXRequestErrorInvalidDataNode];
        }
        else
        {
            id dataNode = [(NSDictionary *)jsonNode objectForKey:@"data"];
            
            if (dataNode && ![dataNode isKindOfClass:[NSDictionary class]])
            {
                *error = [NSError XXXRequestErrorWithCode:XXXRequestErrorInvalidDataNode];
            }
        }
    }
    
    return *error ? nil : dataNode;
}

@end
