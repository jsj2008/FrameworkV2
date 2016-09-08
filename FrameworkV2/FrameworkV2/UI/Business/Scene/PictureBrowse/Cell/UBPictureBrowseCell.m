//
//  UBPictureBrowseCell.m
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPictureBrowseCell.h"
#import "UBPictureBrowsePictureView.h"
#import "UBImageLoader.h"

@interface UBPictureBrowseCell () <UBImageLoaderDelegate>

@property (strong, nonatomic) UIView *pictureView;

@property (strong, nonatomic) UILabel *textLabel;

@property (nonatomic) UBImageLoader *imageLoader;

- (void)customInit;

- (void)showLoading;

- (void)showImage:(UIImage *)image;

- (void)showFailure;

@end


@implementation UBPictureBrowseCell

- (void)dealloc
{
    [self.imageLoader cancel];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self customInit];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self customInit];
}

- (void)customInit
{
    self.textLabel = [[UILabel alloc] init];
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    self.textLabel.textColor = [UIColor redColor];
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    self.textLabel.font = [UIFont systemFontOfSize:14];
    
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pictureView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.textLabel.frame = CGRectMake(0, self.frame.size.height - 100, self.frame.size.width, 100);
}

- (void)setPicture:(UBPictureBrowsePicture *)picture
{
    _picture = picture;
    
    self.imageLoader.delegate = nil;
    
    [self.imageLoader cancel];
    
    if ([picture isKindOfClass:[UBPictureBrowseURLPicture class]])
    {
        // 若图片下载失败过，不再下载图片，直接按照失败处理
        if (((UBPictureBrowseURLPicture *)picture).downloadError)
        {
            [self showFailure];
        }
        else
        {
            [self showLoading];
            
            self.imageLoader = [[UBImageLoader alloc] initWithURL:((UBPictureBrowseURLPicture *)picture).URL];
            
            self.imageLoader.delegate = self;
            
            [self.imageLoader start];
        }
    }
    else if ([picture isKindOfClass:[UBPictureBrowseImagePicture class]])
    {
        self.imageLoader = nil;
        
        [self showImage:((UBPictureBrowseImagePicture *)picture).image];
    }
    
    self.textLabel.text = picture.text;
}

- (void)imageLoader:(UBImageLoader *)imageLoader didFinishWithError:(NSError *)error imageData:(NSData *)data
{
    if ([self.picture isKindOfClass:[UBPictureBrowseURLPicture class]] && [((UBPictureBrowseURLPicture *)self.picture).URL isEqual:imageLoader.URL])
    {
        if (error)
        {
            [self showFailure];
            
            ((UBPictureBrowseURLPicture *)self.picture).downloadError = error;
        }
        else
        {
            [self showImage:(data ? [UIImage imageWithData:data] : nil)];
        }
    }
}

- (void)imageLoader:(UBImageLoader *)imageLoader didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    
}

- (void)showLoading
{
    if (![self.pictureView isKindOfClass:[UBPictureBrowsePictureLoadingView class]])
    {
        [self.pictureView removeFromSuperview];
        
        UBPictureBrowsePictureLoadingView *pictureView = [[UBPictureBrowsePictureLoadingView alloc] init];
        
        self.pictureView = pictureView;
        
        [self addSubview:self.pictureView];
    }
    
    self.textLabel.hidden = YES;
}

- (void)showImage:(UIImage *)image
{
    if (![self.pictureView isKindOfClass:[UBPictureBrowsePictureImageView class]])
    {
        [self.pictureView removeFromSuperview];
        
        UBPictureBrowsePictureImageView *pictureView = [[UBPictureBrowsePictureImageView alloc] init];
        
        pictureView.image = image;
        
        pictureView.maxZoomScale = 2;
        
        pictureView.minZoomScale = 1;
        
        self.pictureView = pictureView;
        
        [self addSubview:self.pictureView];
    }
    
    self.textLabel.hidden = NO;
}

- (void)showFailure
{
    if (![self.pictureView isKindOfClass:[UBPictureBrowsePictureFailureView class]])
    {
        [self.pictureView removeFromSuperview];
        
        UBPictureBrowsePictureFailureView *pictureView = [[UBPictureBrowsePictureFailureView alloc] init];
        
        self.pictureView = pictureView;
        
        [self addSubview:self.pictureView];
    }
    
    self.textLabel.hidden = YES;
}

@end
