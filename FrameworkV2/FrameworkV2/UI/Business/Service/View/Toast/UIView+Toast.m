//
//  UIView+Toast.m
//  FrameworkV2
//
//  Created by ww on 02/11/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UIView+Toast.h"
#import "UBToastView.h"

@implementation UIView (Toast)

- (void)toastWithAttributedMessage:(NSAttributedString *)attributedMessage attributedOptions:(NSArray<NSAttributedString *> *)attributedOptions completion:(void (^)(NSAttributedString *))completion
{
    UBToastView *toastView = [[UBToastView alloc] init];
    
    toastView.attributedMessage = attributedMessage;
    
    toastView.attributedOptions = attributedOptions;
    
    __weak UBToastView *weakToastView = toastView;
    
    toastView.optionOperation = ^(NSAttributedString *attributedOption)
    {
        [weakToastView dismiss];
        
        if (completion)
        {
            completion(attributedOption ? attributedOption : [[NSAttributedString alloc] initWithString:@""]);
        }
    };
    
    toastView.cancelOperation = ^()
    {
        [weakToastView dismiss];
        
        if (completion)
        {
            completion(nil);
        }
    };
    
    toastView.timeout = 3;
    
    [toastView showInView:self];
}

- (void)toastWithMessage:(NSString *)message options:(NSArray<NSString *> *)options completion:(void (^)(NSString *))completion
{
    NSAttributedString *attributedMessage = message ? [[NSAttributedString alloc] initWithString:message] : nil;
    
    NSMutableArray *attributedOptions = [[NSMutableArray alloc] init];
    
    for (NSString *option in options)
    {
        NSAttributedString *attributedOption = [[NSAttributedString alloc] initWithString:option];
        
        [attributedOptions addObject:attributedOption];
    }
    
    [self toastWithAttributedMessage:attributedMessage attributedOptions:attributedOptions completion:^(NSAttributedString *attributedOption) {
        
        if (completion)
        {
            completion(attributedOption.string);
        }
    }];
}

@end
