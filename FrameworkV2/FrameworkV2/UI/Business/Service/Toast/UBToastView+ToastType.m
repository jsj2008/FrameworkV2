//
//  UBToastView+ToastType.m
//  FrameworkV1
//
//  Created by ww on 16/5/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBToastView+ToastType.h"

@implementation UBToastView (ToastType)

+ (UBToastView *)toastViewWithMessage:(NSString *)message options:(NSArray<NSString *> *)options completion:(void (^)(NSString *))completion
{
    UBToastView *toastView = [[UBToastView alloc] init];
    
    toastView.attributedMessage = message ? [[NSAttributedString alloc] initWithString:message] : nil;
    
    NSMutableArray *attributedOptions = [[NSMutableArray alloc] init];
    
    for (NSString *option in options)
    {
        NSAttributedString *attributedOption = [[NSAttributedString alloc] initWithString:option];
        
        [attributedOptions addObject:attributedOption];
    }
    
    toastView.attributedOptions = attributedOptions;
    
    toastView.optionOperation = ^(NSAttributedString *attributedOption)
    {
        if (completion)
        {
            NSString *option = attributedOption.string;
            
            completion(option ? option : @"");
        }
    };
    
    toastView.cancelOperation = ^()
    {
        if (completion)
        {
            completion(nil);
        }
    };
    
    toastView.timeout = 3;
    
    return toastView;
}

@end
