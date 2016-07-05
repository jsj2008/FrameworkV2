//
//  UBPictureBrowseToolBar.m
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPictureBrowseToolBar.h"

@interface UBPictureBrowseToolBar ()

@property (nonatomic) NSArray<UIButton *> *itemButtons;

- (void)buttonPressed:(id)sender;

@end


@implementation UBPictureBrowseToolBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.itemButtons.count; i ++)
    {
        UIButton *button = [self.itemButtons objectAtIndex:i];
        
        button.frame = CGRectMake(self.frame.size.width - (self.itemButtons.count - i) * 30, 0, 30, self.frame.size.height);
    }
}

- (void)setItems:(NSArray<UBPictureBrowseToolBarItem *> *)items
{
    _items = items;
    
    for (UIButton *button in self.itemButtons)
    {
        [button removeFromSuperview];
    }
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    
    for (UBPictureBrowseToolBarItem *item in items)
    {
        UIButton *button = [UIButton buttonWithPictureBrowseToolBarItem:item];
        
        button.enabled = item.isEnabled;
        
        button.selected = item.selected;
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttons addObject:button];
        
        [self addSubview:button];
    }
    
    self.itemButtons = buttons;
}

- (void)updateItem:(UBPictureBrowseToolBarItem *)item
{
    if (!item)
    {
        return;
    }
    
    NSUInteger index = [self.items indexOfObject:item];
    
    if (index != NSNotFound)
    {
        UIButton *button = [self.itemButtons objectAtIndex:index];
        
        button.enabled = item.isEnabled;
        
        button.selected = item.selected;
    }
}

- (void)updateItemWithId:(NSString *)itemId
{
    for (int i = 0; i < self.items.count; i ++)
    {
        UBPictureBrowseToolBarItem *item = [self.items objectAtIndex:i];
        
        if ([item.itemId isEqualToString:itemId])
        {
            UIButton *button = [self.itemButtons objectAtIndex:i];
            
            button.enabled = item.isEnabled;
            
            button.selected = item.selected;
            
            break;
        }
    }
}

- (void)buttonPressed:(id)sender
{
    NSUInteger index = [self.itemButtons indexOfObject:sender];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pictureBrowseToolBar:didSelectItem:)])
    {
        [self.delegate pictureBrowseToolBar:self didSelectItem:[self.items objectAtIndex:index]];
    }
}

@end


@implementation UIButton (PictureBrowseToolBar)

+ (UIButton *)buttonWithPictureBrowseToolBarItem:(UBPictureBrowseToolBarItem *)item
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor clearColor];
    
    [button setTitle:item.itemId forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    return button;
}

@end
