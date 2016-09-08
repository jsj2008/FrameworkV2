//
//  LoginManager.m
//  FrameworkV2
//
//  Created by ww on 16/8/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "LoginManager.h"
#import "NSObject+Delegate.h"

@implementation LoginManager

+ (LoginManager *)sharedInstance
{
    static LoginManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[LoginManager alloc] init];
        }
    });
    
    return instance;
}

- (void)addDelegate:(id<LoginManagerDelegate>)delegate
{
    [super addDelegate:self];
}

- (void)removeDelegate:(id<LoginManagerDelegate>)delegate
{
    [super removeDelegate:self];
}

- (void)loginWithUser:(id)user
{
    _currentLoginedUser = user;
    
    [self operateDelegate:^(id delegate) {
        
        if (delegate && [delegate respondsToSelector:@selector(loginManagerDidLogin:)])
        {
            [delegate loginManagerDidLogin:self];
        }
    }];
}

- (void)logout
{
    _currentLoginedUser = nil;
    
    [self operateDelegate:^(id delegate) {
        
        if (delegate && [delegate respondsToSelector:@selector(loginManagerDidLogout:)])
        {
            [delegate loginManagerDidLogout:self];
        }
    }];
}

@end
