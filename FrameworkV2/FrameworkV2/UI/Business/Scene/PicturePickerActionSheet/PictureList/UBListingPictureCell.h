//
//  UBListingPictureCell.h
//  Test
//
//  Created by ww on 16/6/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

/*********************************************************
 
    @class
        UBListingPictureCell
 
    @abstract
        列表式图片单元格
 
 *********************************************************/

@interface UBListingPictureCell : UICollectionViewCell

/*!
 * @brief 设置图片与配置是否使用远端图片
 * @param picture 图片
 * @param enableRemoteData 是否使用远端图片（iCloud图片等需从远端下载图片）
 */
- (void)setPicture:(PHAsset *)picture enableRemoteData:(BOOL)enableRemoteData;

/*!
 * @brief 图片
 */
@property (nonatomic, readonly) PHAsset *picture;

/*!
 * @brief 是否使用远端图片
 */
@property (nonatomic, readonly) BOOL enableRemoteData;

@end
