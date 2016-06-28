//
//  HTTPRequestResponseContent.m
//  FrameworkV1
//
//  Created by ww on 16/5/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestResponseContent.h"

@interface HTTPRequestResponseContent ()
{
    NSError *_requestError;
    
    NSHTTPURLResponse *_response;
    
    NSData *_data;
}

@end


@implementation HTTPRequestResponseContent

@synthesize requestError = _requestError;

@synthesize response = _response;

@synthesize data = _data;

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
