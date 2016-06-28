//
//  UBTextFieldDataPickerInputToolBar.m
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBTextFieldDataPickerInputToolBar.h"
#import <objc/runtime.h>

static const char kUBTextFieldDataPickerInputToolBarPropertyKey_DataPickerInputAccessoryDelegate[] = "dataPickerInputAccessoryDelegate";


@implementation UBTextFieldDataPickerInputToolBar

- (void)setDataPickerInputAccessoryDelegate:(id<UFDataPickerInputAccessoryDelegate>)dataPickerInputAccessoryDelegate
{
    objc_setAssociatedObject(self, kUBTextFieldDataPickerInputToolBarPropertyKey_DataPickerInputAccessoryDelegate, dataPickerInputAccessoryDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UFDataPickerInputAccessoryDelegate>)dataPickerInputAccessoryDelegate
{
    return objc_getAssociatedObject(self, kUBTextFieldDataPickerInputToolBarPropertyKey_DataPickerInputAccessoryDelegate);
}

@end
