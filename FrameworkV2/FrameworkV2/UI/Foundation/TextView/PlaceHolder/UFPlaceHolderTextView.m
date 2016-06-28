//
//  UFPlaceHolderTextView.m
//  Test
//
//  Created by ww on 16/5/9.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UFPlaceHolderTextView.h"

@interface UFPlaceHolderTextView ()

@property (nonatomic) BOOL isEditing;

@property (nonatomic) BOOL isPlaceHolding;

@property (nonatomic) UFTextViewPlaceHolder *unPlaceHolder;

- (void)customInit;

- (void)didReceiveTextViewTextDidBeginEditingNotification:(NSNotification *)notification;

- (void)didReceiveTextViewTextDidEndEditingNotification:(NSNotification *)notification;

@end


@implementation UFPlaceHolderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self customInit];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self customInit];
}

- (void)customInit
{
    self.unPlaceHolder = [[UFTextViewPlaceHolder alloc] init];
    
    self.unPlaceHolder.text = super.text;
    
    self.unPlaceHolder.textColor = super.textColor;
    
    self.unPlaceHolder.font = super.font;
}

- (void)setPlaceHolder:(UFTextViewPlaceHolder *)placeHolder
{
    _placeHolder = placeHolder;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewTextDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTextViewTextDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.unPlaceHolder.text = self.text;
    
    self.unPlaceHolder.textColor = self.textColor;
    
    self.unPlaceHolder.font = self.font;
    
    if (!self.isEditing && [super.text length] == 0)
    {
        super.text = self.placeHolder.text;
        
        super.textColor = self.placeHolder.textColor;
        
        super.font = self.placeHolder.font;
        
        self.isPlaceHolding = YES;
    }
}

- (void)setText:(NSString *)text
{
    if ([text length] > 0)
    {
        super.text = text;
        
        super.textColor = self.unPlaceHolder.textColor;
        
        super.font = self.unPlaceHolder.font;
        
        self.isPlaceHolding = NO;
    }
    else
    {
        super.text = self.placeHolder.text;
        
        super.textColor = self.placeHolder.textColor;
        
        super.font = self.placeHolder.font;
        
        self.isPlaceHolding = YES;
    }
}

- (NSString *)text
{
    return self.isPlaceHolding ? nil : super.text;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.unPlaceHolder.textColor = textColor;
    
    if (!self.isPlaceHolding)
    {
        super.textColor = textColor;
    }
}

- (UIColor *)textColor
{
    return self.isPlaceHolding ? self.unPlaceHolder.textColor : super.textColor;
}

- (void)setFont:(UIFont *)font
{
    self.unPlaceHolder.font = font;
    
    if (!self.isPlaceHolding)
    {
        super.font = font;
    }
}

- (UIFont *)font
{
    return self.isPlaceHolding ? self.unPlaceHolder.font : super.font;
}

- (void)didReceiveTextViewTextDidBeginEditingNotification:(NSNotification *)notification
{
    self.isEditing = YES;
    
    if (self.isPlaceHolding)
    {
        super.text = nil;
        
        super.textColor = self.unPlaceHolder.textColor;
        
        super.font = self.unPlaceHolder.font;
        
        self.isPlaceHolding = NO;
    }
}

- (void)didReceiveTextViewTextDidEndEditingNotification:(NSNotification *)notification
{
    self.isEditing = NO;
    
    self.unPlaceHolder.text = super.text;
    
    self.unPlaceHolder.textColor = super.textColor;
    
    self.unPlaceHolder.font = super.font;
    
    if ([super.text length] == 0)
    {
        super.text = self.placeHolder.text;
        
        super.textColor = self.placeHolder.textColor;
        
        super.font = self.placeHolder.font;
        
        self.isPlaceHolding = YES;
    }
    else
    {
        self.isPlaceHolding = NO;
    }
}

@end
