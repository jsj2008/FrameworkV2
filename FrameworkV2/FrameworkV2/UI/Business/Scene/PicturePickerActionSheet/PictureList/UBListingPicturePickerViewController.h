//
//  UBListingPicturePickerViewController.h
//  FrameworkV1
//
//  Created by ww on 16/6/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol UBListingPicturePickerViewControllerDelegate;


/*********************************************************
 
    @class
        UBListingPicturePickerViewController
 
    @abstract
        列表式图片选择视图控制器
 
 *********************************************************/

@interface UBListingPicturePickerViewController : UIViewController

/*!
 * @brief 消息代理
 */
@property (nonatomic, weak) id<UBListingPicturePickerViewControllerDelegate> delegate;

/*!
 * @brief 是否使用远端图片（iCloud图片等需从远端下载图片）
 * @discussion 使用时，显示的iCloud图片将从远端下载图片显示
 */
@property (nonatomic) BOOL enableRemoteImages;

/*!
 * @brief 图片集合
 * @discussion 若指定该集合，将只加载集合内图片，否则加载所有能加载到的图片
 */
@property (nonatomic) PHAssetCollection *pictureColletion;

/*!
 * @brief 是否允许多选照片
 */
@property (nonatomic) BOOL allowsMultipleSelection;

@end


/*********************************************************
 
    @protocol
        UBListingPicturePickerViewControllerDelegate
 
    @abstract
       列表式图片选择视图控制器消息代理协议
 
 *********************************************************/

@protocol UBListingPicturePickerViewControllerDelegate <NSObject>

/*!
 * @brief 选择结束
 * @param controller 视图控制器
 * @param images 被选中的图片
 */
- (void)listingPicturePickerViewController:(UBListingPicturePickerViewController *)controller didFinishWithPickedImages:(NSArray<UIImage *> *)images;

@end
