//
//  UFScrollLoadingView.m
//  Test
//
//  Created by ww on 16/2/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollLoadingView.h"

@implementation UFScrollLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self reset];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self reset];
}

- (void)start
{
    self.status = UFScrollLoadingViewStatus_Loading;
    
    [self customStartWithCompletion:nil];
}

- (void)customStartWithCompletion:(void (^)(void))completion
{
    if (completion)
    {
        completion();
    }
}

- (void)stop
{
    [self customStopWithCompletion:nil];
}

- (void)customStopWithCompletion:(void (^)(void))completion
{
    if (completion)
    {
        completion();
    }
}

- (void)prepare
{
    self.status = UFScrollLoadingViewStatus_Prepare;
    
    [self customPrepareWithCompletion:nil];
}

- (void)customPrepareWithCompletion:(void (^)(void))completion
{
    if (completion)
    {
        completion();
    }
}

- (void)reset
{
    self.status = UFScrollLoadingViewStatus_Reset;
    
    [self customResetWithCompletion:nil];
}

- (void)customResetWithCompletion:(void (^)(void))completion
{
    if (completion)
    {
        completion();
    }
}

@end
