//
//  UBPictureBrowseToolBar.h
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBPictureBrowseToolBarItem.h"

@protocol UBPictureBrowseToolBarDelegate;


/*********************************************************
 
    @class
        UBPictureBrowseToolBar
 
    @abstract
        图片浏览工具栏
 
 *********************************************************/

@interface UBPictureBrowseToolBar : UIView

/*!
 * @brief 代理对象
 */
@property (nonatomic, weak) id<UBPictureBrowseToolBarDelegate> delegate;

/*!
 * @brief 工具项
 */
@property (nonatomic) NSArray<UBPictureBrowseToolBarItem *> *items;

/*!
 * @brief 更新指定工具项
 * @param item 工具项
 */
- (void)updateItem:(UBPictureBrowseToolBarItem *)item;

/*!
 * @brief 更新指定工具项
 * @param itemId 工具项ID
 */
- (void)updateItemWithId:(NSString *)itemId;

@end


/*********************************************************
 
    @protocol
        UBPictureBrowseToolBarDelegate
 
    @abstract
        图片浏览工具栏消息代理协议
 
 *********************************************************/

@protocol UBPictureBrowseToolBarDelegate <NSObject>

/*!
 * @brief 选中工具项
 * @param toolBar 工具栏
 * @param item 被选中的工具项
 */
- (void)pictureBrowseToolBar:(UBPictureBrowseToolBar *)toolBar didSelectItem:(UBPictureBrowseToolBarItem *)item;

@end


/*********************************************************
 
    @category
        UIButton (PictureBrowseToolBar)
 
    @abstract
        按钮的图片浏览工具栏扩展
 
 *********************************************************/

@interface UIButton (PictureBrowseToolBar)

/*!
 * @brief 按照工具项生成指定样式的按钮
 * @discussion 生成的按钮只能配置样式，不要添加消息处理等操作
 * @param item 工具项
 * @result 按钮
 */
+ (UIButton *)buttonWithPictureBrowseToolBarItem:(UBPictureBrowseToolBarItem *)item;

@end
