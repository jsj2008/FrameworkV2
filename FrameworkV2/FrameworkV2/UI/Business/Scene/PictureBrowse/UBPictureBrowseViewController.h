//
//  UBPictureBrowseViewController.h
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBPictureBrowsePicture.h"
#import "UBPictureBrowseToolBarItem.h"

/*********************************************************
 
    @class
        UBPictureBrowseViewController
 
    @abstract
        图片浏览视图控制器
 
 *********************************************************/

@interface UBPictureBrowseViewController : UIViewController

/*!
 * @brief 浏览器图片
 */
@property (nonatomic) NSArray<UBPictureBrowsePicture *> *pictures;

/*!
 * @brief 当前可见图片
 */
@property (nonatomic, readonly) UBPictureBrowsePicture *visiblePicture;

/*!
 * @brief 可选的工具栏选项
 */
@property (nonatomic) NSArray<NSString *> *toolBarItemIds;

/*!
 * @brief 显示指定图片
 * @param picture 显示图片
 * @param animated 是否需要动画
 */
- (void)showPicture:(UBPictureBrowsePicture *)picture animated:(BOOL)animated;

@end
