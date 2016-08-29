//
//  HTTPRequestResponseContent.m
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestResponseContent.h"

@implementation HTTPRequestResponseContent

- (instancetype)initWithRequestError:(NSError *)error response:(NSHTTPURLResponse *)response data:(NSData *)data
{
    if (self = [super init])
    {
        _requestError = error;
        
        _response = response;
        
        _data = data;
    }
    
    return self;
}

@end
