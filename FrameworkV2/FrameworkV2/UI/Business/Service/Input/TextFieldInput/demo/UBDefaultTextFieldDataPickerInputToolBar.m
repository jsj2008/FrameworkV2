//
//  UBDefaultTextFieldDataPickerInputToolBar.m
//  Test
//
//  Created by ww on 16/6/20.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBDefaultTextFieldDataPickerInputToolBar.h"

@interface UBDefaultTextFieldDataPickerInputToolBar ()

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)confirmButtonPressed:(id)sender;


@end


@implementation UBDefaultTextFieldDataPickerInputToolBar

- (void)cancelButtonPressed:(id)sender
{
    if (self.dataPickerInputAccessoryDelegate && [self.dataPickerInputAccessoryDelegate respondsToSelector:@selector(dataPickerInputAccessoryDidCancel:)])
    {
        [self.dataPickerInputAccessoryDelegate dataPickerInputAccessoryDidCancel:self];
    }
}

- (void)confirmButtonPressed:(id)sender
{
    if (self.dataPickerInputAccessoryDelegate && [self.dataPickerInputAccessoryDelegate respondsToSelector:@selector(dataPickerInputAccessoryDidConfirm:)])
    {
        [self.dataPickerInputAccessoryDelegate dataPickerInputAccessoryDidConfirm:self];
    }
}

@end
