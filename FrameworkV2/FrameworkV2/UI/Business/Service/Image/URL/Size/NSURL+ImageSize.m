//
//  NSURL+ImageSize.m
//  FrameworkV2
//
//  Created by ww on 16/8/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NSURL+ImageSize.h"

@implementation NSURL (ImageSize)

- (NSURL *)imageURLWithPointSize:(CGSize)pointSize
{
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    
    NSURLQueryItem *sizeItem = [NSURLQueryItem queryItemWithName:@"size" value:[NSString stringWithFormat:@"%dx%d", (int)(pointSize.width * [UIScreen mainScreen].scale), (int)(pointSize.height * [UIScreen mainScreen].scale)]];
    
    if (components.queryItems.count > 0)
    {
        components.queryItems = [components.queryItems arrayByAddingObject:sizeItem];
    }
    else
    {
        components.queryItems = [NSArray arrayWithObject:sizeItem];
    }
    
    return components.URL;
}

@end
