//
//  UBTextFieldInputToolBar.m
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldInputToolBar.h"

@interface UBTextFieldInputToolBar ()

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)okButtonPressed:(id)sender;

@end


@implementation UBTextFieldInputToolBar

- (IBAction)cancelButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldInputToolBarDidCancel:)])
    {
        [self.delegate textFieldInputToolBarDidCancel:self];
    }
}

- (IBAction)okButtonPressed:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldInputToolBarDidConfirm:)])
    {
        [self.delegate textFieldInputToolBarDidConfirm:self];
    }
}

@end
