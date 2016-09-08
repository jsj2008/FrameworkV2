//
//  UBPictureBrowseToolBarItem.h
//  FrameworkV2
//
//  Created by ww on 16/7/5.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

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
