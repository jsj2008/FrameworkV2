//
//  UBActivityIndicatorView.m
//  FrameworkV2
//
//  Created by ww on 16/8/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBActivityIndicatorView.h"

@implementation UBActivityIndicatorView

- (void)startAnimating
{
    _isAnimating = YES;
}

- (void)stopAnimating
{
    _isAnimating = NO;
}

@end
