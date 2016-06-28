//
//  HTTPResponseHeader.m
//  HS
//
//  Created by ww on 16/5/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPResponseHeader.h"

@implementation HTTPResponseHeader

- (id)copyWithZone:(NSZone *)zone
{
    HTTPResponseHeader *one = [[HTTPResponseHeader alloc] init];
    
    one.version = self.version;
    
    one.statusCode = self.statusCode;
    
    one.statusDescription = self.statusDescription;
    
    one.headerFields = [self.headerFields copy];
    
    return one;
}

@end
