//
//  Task+Operation.m
//  Test
//
//  Created by ww on 16/6/28.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "Task+Operation.h"
#import <objc/runtime.h>

static const char kTaskPropertyKey_MarkOperationCancel[] = "markOperationCancel";


@implementation Task (Operation)

- (void)setMarkOperationCancel:(BOOL)markOperationCancel
{
    objc_setAssociatedObject(self, kTaskPropertyKey_MarkOperationCancel, [NSNumber numberWithBool:markOperationCancel], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)markOperationCancel
{
    return [(NSNumber *)objc_getAssociatedObject(self, kTaskPropertyKey_MarkOperationCancel) boolValue];
}

- (void)triggerOperationThread
{
    
}

@end
