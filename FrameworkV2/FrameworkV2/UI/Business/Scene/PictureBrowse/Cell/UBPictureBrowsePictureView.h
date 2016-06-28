//
//  UBPictureBrowsePictureView.h
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UBPictureBrowsePictureLoadingView
 
    @abstract
        图片加载状态的视图
 
 *********************************************************/

@interface UBPictureBrowsePictureLoadingView : UIView

@end


/*********************************************************
 
    @class
        UBPictureBrowsePictureImageView
 
    @abstract
        图片视图
 
 *********************************************************/

@interface UBPictureBrowsePictureImageView : UIScrollView

/*!
 * @brief 图片
 */
@property (nonatomic) UIImage *image;

/*!
 * @brief 最大缩放比例
 * @discussion 至少为1，小于1按照1处理
 */
@property (nonatomic) CGFloat maxZoomScale;

/*!
 * @brief 最小缩放比例
 * @discussion 至多为1，大于1按照1处理
 */
@property (nonatomic) CGFloat minZoomScale;

@end


/*********************************************************
 
    @class
        UBPictureBrowsePictureFailureView
 
    @abstract
        图片加载失败的视图
 
 *********************************************************/

@interface UBPictureBrowsePictureFailureView : UIView

@end
