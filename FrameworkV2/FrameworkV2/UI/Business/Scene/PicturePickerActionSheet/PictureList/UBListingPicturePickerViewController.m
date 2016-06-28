//
//  UBListingPicturePickerViewController.m
//  FrameworkV1
//
//  Created by ww on 16/6/16.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBListingPicturePickerViewController.h"
#import "UBListingPictureCell.h"

static NSString * kCellIdentifier = @"cell";


@interface UBListingPicturePickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *pictureView;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic) PHFetchResult *pictures;

@property (nonatomic) NSMutableArray<PHAsset *> *selectedPictures;

- (IBAction)cancelButtonPressed:(id)sender;

- (IBAction)confirmButtonPressed:(id)sender;

- (void)finishWithPickedImages:(NSArray<UIImage *> *)images;

@end


@implementation UBListingPicturePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.pictureView registerNib:[UINib nibWithNibName:NSStringFromClass([UBListingPictureCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    self.pictureView.allowsMultipleSelection = self.allowsMultipleSelection;
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    
    fetchOptions.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    if (self.pictureColletion)
    {
        self.pictures = [PHAsset fetchAssetsInAssetCollection:self.pictureColletion options:fetchOptions];
    }
    else
    {
        self.pictures = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    }
    
    [self.pictureView reloadData];
    
    self.selectedPictures = [[NSMutableArray alloc] init];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(0.25 * self.view.frame.size.width, 0.25 * self.view.frame.size.height);
    
    layout.minimumInteritemSpacing = 0;
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0.1 * self.view.frame.size.width, 0, 0.1 * self.view.frame.size.width);
    
    self.pictureView.collectionViewLayout = layout;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self finishWithPickedImages:nil];
}

- (IBAction)confirmButtonPressed:(id)sender
{
    if (self.selectedPictures.count == 0)
    {
        [self finishWithPickedImages:nil];
    }
    else
    {
        NSMutableArray *pictureImages = [[NSMutableArray alloc] init];
        
        __block NSUInteger requestCount = self.selectedPictures.count;
        
        __weak typeof(self) weakSelf = self;
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        
        options.version = PHImageRequestOptionsVersionOriginal;
        
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        
        options.normalizedCropRect = CGRectZero;
        
        options.networkAccessAllowed = YES;
        
        options.synchronous = NO;
        
        for (PHAsset *picture in self.selectedPictures)
        {
            [[PHImageManager defaultManager] requestImageForAsset:picture targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                if (result)
                {
                    [pictureImages addObject:result];
                }
                
                requestCount --;
                
                if (requestCount <= 0)
                {
                    [weakSelf finishWithPickedImages:pictureImages];
                }
            }];
        };
    }
}

- (void)finishWithPickedImages:(NSArray<UIImage *> *)images
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(listingPicturePickerViewController:didFinishWithPickedImages:)])
    {
        [self.delegate listingPicturePickerViewController:self didFinishWithPickedImages:images];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UBListingPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell setPicture:[self.pictures objectAtIndex:indexPath.item] enableRemoteData:self.enableRemoteImages];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedPictures addObject:[self.pictures objectAtIndex:indexPath.item]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedPictures removeObject:[self.pictures objectAtIndex:indexPath.item]];
}

@end
