//
//  NetworkManager.m
//  FrameworkV1
//
//  Created by ww on 16/4/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "NetworkManager.h"
#import "NSObject+Delegate.h"

@interface NetworkManager ()

@property (nonatomic) NetworkReachability *reachability;

- (void)didChangeFromStatus:(NetworkReachStatus)fromStatus toStatus:(NetworkReachStatus)toStatus;

@end


@implementation NetworkManager

- (instancetype)init
{
    if (self = [super init])
    {
        self.reachability = [NetworkReachability reachabilityForInternetConnection];
        
        __weak typeof(self) weakSelf = self;
        
        self.reachability.notificationBlock = ^(NetworkReachStatus fromStatus, NetworkReachStatus toStatus){
            
            [weakSelf didChangeFromStatus:fromStatus toStatus:toStatus];
        };
    }
    
    return self;
}

+ (NetworkManager *)sharedInstance
{
    static NetworkManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[NetworkManager alloc] init];
        }
    });
    
    return instance;
}

- (NetworkReachStatus)currentNetworkReachStatus
{
    return self.reachability.status;
}

- (void)addDelegate:(id<NetworkManagerDelegate>)delegate
{
    [super addDelegate:delegate];
}

- (void)removeDelegate:(id<NetworkManagerDelegate>)delegate
{
    [super removeDelegate:delegate];
}

- (void)start
{
    [self.reachability startNotifier];
}

- (void)stop
{
    [self.reachability stopNotifier];
}

- (void)didChangeFromStatus:(NetworkReachStatus)fromStatus toStatus:(NetworkReachStatus)toStatus
{
    [self operateDelegate:^(id delegate) {
        
        if (delegate && [delegate respondsToSelector:@selector(networkManager:didChangeFromStatus:toStatus:)])
        {
            [delegate networkManager:self didChangeFromStatus:fromStatus toStatus:toStatus];
        }
    }];
}

@end
