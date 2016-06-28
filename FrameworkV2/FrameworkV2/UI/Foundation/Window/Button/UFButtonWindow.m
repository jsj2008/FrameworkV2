//
//  UFButtonWindow.m
//  MarryYou
//
//  Created by ww on 15/11/16.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import "UFButtonWindow.h"

@interface UFButtonWindow ()

- (void)customInit;

@property (nonatomic) UIButton *button;

- (void)buttonPressed;

@end


@implementation UFButtonWindow

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
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.button.backgroundColor = [UIColor clearColor];
    
    self.button.titleLabel.text = nil;
    
    [self.button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.button];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)buttonPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonWindowDidPressed:)])
    {
        [self.delegate buttonWindowDidPressed:self];
    }
}

@end
