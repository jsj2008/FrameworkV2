//
//  UBPictureBrowseToolBar.h
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UBPictureBrowseToolBarItem;

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
 
    @class
        UBPictureBrowseToolBarItem
 
    @abstract
        图片浏览工具项
 
 *********************************************************/

@interface UBPictureBrowseToolBarItem : NSObject

/*!
 * @brief ID
 */
@property (nonatomic, copy) NSString *itemId;

/*!
 * @brief 使能状态
 */
@property (nonatomic, getter=isEnabled) BOOL enable;

/*!
 * @brief 选中状态
 */
@property (nonatomic) BOOL selected;

@end


// 这里定义工具项的ID
extern NSString * const kPictureBrowseToolBarItemId_Share;
