//
//  UBListingPictureCell.m
//  Test
//
//  Created by ww on 16/6/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBListingPictureCell.h"

@interface UBListingPictureCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) PHImageRequestID requestId;

- (void)updateRequestProgress:(double)progress withInfo:(NSDictionary *)info;

- (void)finishRequestWithError:(NSError *)error image:(UIImage *)image info:(NSDictionary *)info;

@end


@implementation UBListingPictureCell

- (void)dealloc
{
    [[PHImageManager defaultManager] cancelImageRequest:self.requestId];
}

- (void)setPicture:(PHAsset *)picture enableRemoteData:(BOOL)enableRemoteData
{
    _picture = picture;
    
    _enableRemoteData = enableRemoteData;
    
    __weak typeof(self) weakSelf = self;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    options.version = PHImageRequestOptionsVersionOriginal;
    
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    options.normalizedCropRect = CGRectZero;
    
    options.networkAccessAllowed = self.enableRemoteData;
    
    options.synchronous = NO;
    
    options.progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info)
    {
        PHImageRequestID requestId = [[info objectForKey:PHImageResultRequestIDKey] intValue];
        
        if (requestId == weakSelf.requestId)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error)
                {
                    [weakSelf finishRequestWithError:error image:nil info:info];
                }
                else
                {
                    [weakSelf updateRequestProgress:progress withInfo:info];
                }
            });
        }
        
        if (error)
        {
            *stop = YES;
        }
    };
    
    PHImageRequestID requestId = [[PHImageManager defaultManager] requestImageForAsset:picture targetSize:CGSizeMake(self.frame.size.width * [UIScreen mainScreen].scale, self.frame.size.height * [UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        PHImageRequestID requestId = [[info objectForKey:PHImageResultRequestIDKey] intValue];
        
        if (requestId == weakSelf.requestId)
        {
            [weakSelf finishRequestWithError:nil image:result info:info];
        }
    }];
    
    if (requestId != self.requestId)
    {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestId];
    }
    
    self.requestId = requestId;
    
    self.userInteractionEnabled = NO;
}

- (void)updateRequestProgress:(double)progress withInfo:(NSDictionary *)info
{
    
}

- (void)finishRequestWithError:(NSError *)error image:(UIImage *)image info:(NSDictionary *)info
{
    if (!error)
    {
        self.imageView.image = image;
    }
    
    self.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.imageView.layer.borderColor = [[UIColor redColor] CGColor];
        
        self.imageView.layer.borderWidth = 2;
    }
    else
    {
        self.imageView.layer.borderWidth = 0;
    }
}

@end
