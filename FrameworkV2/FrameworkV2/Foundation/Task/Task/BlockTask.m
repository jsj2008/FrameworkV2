//
//  BlockTask.m
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "BlockTask.h"

@implementation BlockTask

- (instancetype)init
{
    if (self = [super init])
    {
        _context = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)main
{
    if (self.block)
    {
        self.block();
    }
    
    [self cancel];
    
    [self notify:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(blockTaskDidFinish:)])
        {
            [self.delegate blockTaskDidFinish:self];
        }
        
    } onThread:self.notifyThread];
}

@end
