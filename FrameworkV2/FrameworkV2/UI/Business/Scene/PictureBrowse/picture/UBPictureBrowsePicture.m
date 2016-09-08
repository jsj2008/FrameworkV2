//
//  UBPictureBrowsePicture.m
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPictureBrowsePicture.h"
#import <objc/runtime.h>

@implementation UBPictureBrowsePicture

@end


@implementation UBPictureBrowseURLPicture

@end


@implementation UBPictureBrowseImagePicture

@end


static const char kUBPictureBrowseURLPicturePropertyKey_DownloadError[] = "downloadError";


@implementation UBPictureBrowseURLPicture (Download)

- (void)setDownloadError:(NSError *)downloadError
{
    objc_setAssociatedObject(self, kUBPictureBrowseURLPicturePropertyKey_DownloadError, downloadError, OBJC_ASSOCIATION_RETAIN);
}

- (NSError *)downloadError
{
    return objc_getAssociatedObject(self, kUBPictureBrowseURLPicturePropertyKey_DownloadError);
}

@end
