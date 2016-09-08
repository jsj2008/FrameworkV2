//
//  UFInputButton.m
//  FrameworkV2
//
//  Created by ww on 16/6/30.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UFInputButton.h"

@implementation UFInputButton

- (void)showInput
{
    [self becomeFirstResponder];
}

- (void)hideInput
{
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
