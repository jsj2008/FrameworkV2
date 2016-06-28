//
//  HTTPRequestTask.m
//  FrameworkV1
//
//  Created by ww on 16/5/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestTask.h"

@interface HTTPRequestTask ()
{
    NSURL *_URL;
}

@end


@implementation HTTPRequestTask

@synthesize URL = _URL;

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init])
    {
        _URL = [URL copy];
    }
    
    return self;
}

@end


@implementation HTTPRequestInternetPassword

- (instancetype)initWithUser:(NSString *)user password:(NSString *)password
{
    if (self = [super init])
    {
        self.user = user;
        
        self.password = password;
    }
    
    return self;
}

@end
