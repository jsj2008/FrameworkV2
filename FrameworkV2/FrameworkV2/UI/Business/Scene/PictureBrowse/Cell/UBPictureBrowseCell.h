//
//  UBPictureBrowseCell.h
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UBPictureBrowsePicture.h"

/*********************************************************
 
    @class
        UBPictureBrowseCell
 
    @abstract
        图片浏览Cell
 
 *********************************************************/

@interface UBPictureBrowseCell : UICollectionViewCell

/*!
 * @brief 图片
 */
@property (nonatomic) UBPictureBrowsePicture *picture;

@end
