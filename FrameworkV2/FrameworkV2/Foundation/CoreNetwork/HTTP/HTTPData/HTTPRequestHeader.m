//
//  HTTPRequestHeader.m
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestHeader.h"

@implementation HTTPRequestHeader

- (id)copyWithZone:(NSZone *)zone
{
    HTTPRequestHeader *one = [[HTTPRequestHeader alloc] init];
    
    one.version = self.version;
    
    one.URL = self.URL;
    
    one.method = self.method;
    
    one.headerFields = [self.headerFields copy];
    
    return one;
}

@end
