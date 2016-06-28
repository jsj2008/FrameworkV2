//
//  UBPictureBrowsePictureView.m
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPictureBrowsePictureView.h"

@interface UBPictureBrowsePictureLoadingView ()

@property (nonatomic) UILabel *textLabel;

- (void)customInit;

@end


@implementation UBPictureBrowsePictureLoadingView

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
    self.backgroundColor = [UIColor grayColor];
    
    self.textLabel = [[UILabel alloc] init];
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    self.textLabel.font = [UIFont systemFontOfSize:20];
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    self.textLabel.textColor = [UIColor blackColor];
    
    self.textLabel.text = @"加载中";
    
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end


@interface UBPictureBrowsePictureImageView () <UIScrollViewDelegate>

@property (nonatomic) UIImageView *imageView;

- (void)customInit;

- (void)updateZooming;

@end


@implementation UBPictureBrowsePictureImageView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
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
    self.delegate = self;
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.showsVerticalScrollIndicator = NO;
    
    self.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    self.imageView = [[UIImageView alloc] init];
    
    self.imageView.contentMode = UIViewContentModeCenter;
    
    [self addSubview:self.imageView];
    
    self.maxZoomScale = 1;
    
    self.minZoomScale = 1;
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.bounds = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    self.imageView.center = CGPointMake(0.5 * self.frame.size.width, 0.5 * self.frame.size.height);
    
    CGRect frame = self.imageView.frame;
    
    if (frame.size.width > self.frame.size.width)
    {
        frame.origin.x = 0;
    }
    
    if (frame.size.height > self.frame.size.height)
    {
        frame.origin.y = 0;
    }
    
    self.imageView.frame = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        [self updateZooming];
    }
}

- (void)updateZooming
{
    CGFloat imageWidthScale = self.frame.size.width > 0 ? self.imageView.image.size.width / self.frame.size.width : MAXFLOAT;
    
    CGFloat imageHeightScale = self.frame.size.height > 0 ? self.imageView.image.size.height / self.frame.size.height : MAXFLOAT;
    
    CGFloat imageScale = MAX(imageWidthScale, imageHeightScale);
    
    // 图片原始尺寸超过自身尺寸时，需要进行显示上的尺寸压缩；未超过时，不压缩，也不放大（避免模糊）
    if (imageScale > 1)
    {
        self.minimumZoomScale = self.minZoomScale / imageScale;
        
        self.maximumZoomScale = self.maxZoomScale / imageScale;
        
        self.zoomScale = 1 / imageScale;
        
        // 校正因为float除法带来的误差，以保证最小缩放和当前缩放必须在自身视图范围内，否则collectionView会无法拖动
        
        if (self.minimumZoomScale * self.imageView.image.size.width > self.minZoomScale * self.frame.size.width)
        {
            self.minimumZoomScale = (self.frame.size.width - 0.1) / self.imageView.image.size.width;
        }
        
        if (self.minimumZoomScale * self.imageView.image.size.height > self.maxZoomScale * self.frame.size.height)
        {
            self.minimumZoomScale = (self.frame.size.height - 0.1) / self.imageView.image.size.height;
        }
        
        if (self.zoomScale * self.imageView.image.size.width > self.frame.size.width)
        {
            self.zoomScale = (self.frame.size.width - 0.1) / self.imageView.image.size.width;
        }
        
        if (self.zoomScale * self.imageView.image.size.height > self.frame.size.height)
        {
            self.zoomScale = (self.frame.size.height - 0.1) / self.imageView.image.size.height;
        }
    }
    else
    {
        self.minimumZoomScale = self.minZoomScale;
        
        self.maximumZoomScale = self.maxZoomScale;
        
        self.zoomScale = 1;
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    
    [self updateZooming];
}

- (void)setMaxZoomScale:(CGFloat)maxZoomScale
{
    _maxZoomScale = maxZoomScale;
    
    if (_maxZoomScale < 1)
    {
        _maxZoomScale = 1;
    }
}

- (void)setMinZoomScale:(CGFloat)minZoomScale
{
    _minZoomScale = minZoomScale;
    
    if (_minZoomScale > 1)
    {
        _minZoomScale = 1;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self setNeedsLayout];
}

@end


@interface UBPictureBrowsePictureFailureView ()

@property (nonatomic) UILabel *textLabel;

- (void)customInit;

@end


@implementation UBPictureBrowsePictureFailureView

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
    self.backgroundColor = [UIColor grayColor];
    
    self.textLabel = [[UILabel alloc] init];
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    self.textLabel.font = [UIFont systemFontOfSize:20];
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    self.textLabel.textColor = [UIColor blackColor];
    
    self.textLabel.text = @"加载失败";
    
    [self addSubview:self.textLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
