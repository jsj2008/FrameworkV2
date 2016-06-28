//
//  UBPictureBrowseAccessoryDownloader.h
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBPictureBrowsePicture.h"

/*********************************************************
 
    @class
        UBPictureBrowseAccessoryDownloader
 
    @abstract
        图片浏览辅助下载器
 
    @discussion
        下载器下载图片，但不发送任何通知和消息
 
 *********************************************************/

@interface UBPictureBrowseAccessoryDownloader : NSObject

/*!
 * @brief 最大并发下载量
 * @discussion 下载量超过该值时，将按照下载时间取消最先的下载以保证并发量
 */
@property (nonatomic) NSUInteger maxConcurrentDownloadCount;

/*!
 * @brief 下载图片
 * @param picture 图片
 */
- (void)downloadPicture:(UBPictureBrowseURLPicture *)picture;

/*!
 * @brief 取消所有下载
 */
- (void)cancel;

@end
