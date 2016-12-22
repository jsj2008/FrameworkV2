//
//  UBToastView.m
//  FrameworkV1
//
//  Created by ww on 16/5/18.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBToastView.h"

@interface UBToastView ()

@property (nonatomic) UILabel *messageLabel;

@property (nonatomic) NSMutableArray<UIButton *> *optionButtons;

- (void)customInit;

- (void)buttonPressed:(id)sender;

- (void)didSelectOption:(NSAttributedString *)attributedOption;

- (void)didCancel;

@property (nonatomic) BOOL finished;

@end


@implementation UBToastView

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
    self.messageLabel = [[UILabel alloc] init];
    
    [self addSubview:self.messageLabel];
    
    self.optionButtons = [[NSMutableArray alloc] init];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
                                            [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
                                            [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                             [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                             [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0], nil]];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.timeout > 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf didCancel];
        });
    }
}

- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage
{
    _attributedMessage = [attributedMessage copy];
    
    self.messageLabel.attributedText = attributedMessage;
    
    [self setNeedsLayout];
}

- (void)setAttributedOptions:(NSArray<NSAttributedString *> *)attributedOptions
{
    _attributedOptions = attributedOptions;
    
    for (UIButton *button in self.optionButtons)
    {
        [button removeFromSuperview];
    }
    
    [self.optionButtons removeAllObjects];
    
    for (NSAttributedString *attributedOption in attributedOptions)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setAttributedTitle:attributedOption forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [self.optionButtons addObject:button];
    }
}

- (void)buttonPressed:(id)sender
{
    [self didSelectOption:[((UIButton *)sender) attributedTitleForState:UIControlStateNormal]];
}

- (void)didSelectOption:(NSAttributedString *)attributedOption
{
    if (!self.finished && self.optionOperation)
    {
        self.finished = YES;
        
        self.optionOperation(attributedOption);
    }
}

- (void)didCancel
{
    if (!self.finished && self.cancelOperation)
    {
        self.finished = YES;
        
        self.cancelOperation();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 在这里布局显示文本和按钮
}

@end
