//
//  UBPictureBrowseViewController.m
//  FrameworkV1
//
//  Created by ww on 16/6/12.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPictureBrowseViewController.h"
#import "UBPictureBrowseCell.h"
#import "UBPictureBrowseToolBar.h"
#import "UBPictureBrowseAccessoryDownloader.h"

static NSString * const kCellIdentifier = @"cell";


@interface UBPictureBrowseViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UBPictureBrowseToolBarDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *pictureView;

@property (strong, nonatomic) IBOutlet UBPictureBrowseToolBar *toolBar;

@property (nonatomic) UBPictureBrowseAccessoryDownloader *accessoryDownloader;

@end


@implementation UBPictureBrowseViewController

- (void)dealloc
{
    [self.accessoryDownloader cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.pictureView registerClass:[UBPictureBrowseCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    
    for (NSString *itemId in self.toolBarItemIds)
    {
        UBPictureBrowseToolBarItem *item = [[UBPictureBrowseToolBarItem alloc] init];
        
        item.itemId = itemId;
        
        item.enable = YES;
        
        item.selected = NO;
        
        [toolBarItems addObject:item];
    }
    
    self.toolBar.items = toolBarItems;
    
    self.toolBar.delegate = self;
    
    self.toolBar.backgroundColor = [UIColor grayColor];
    
    self.toolBar.hidden = self.toolBarItemIds.count == 0;
    
    self.accessoryDownloader = [[UBPictureBrowseAccessoryDownloader alloc] init];
    
    self.accessoryDownloader.maxConcurrentDownloadCount = 3;
    
    [self showPicture:self.startPicture animated:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(self.pictureView.frame.size.width, self.pictureView.frame.size.height);
    
    layout.minimumInteritemSpacing = 0;
    
    layout.minimumLineSpacing = 0;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.pictureView.collectionViewLayout = layout;
}

- (UBPictureBrowsePicture *)visiblePicture
{
    UBPictureBrowseCell *cell = [[self.pictureView visibleCells] firstObject];
    
    return cell.picture;
}

- (void)showPicture:(UBPictureBrowsePicture *)picture animated:(BOOL)animated
{
    if (!picture)
    {
        return;
    }
    
    NSUInteger index = [self.pictures indexOfObject:picture];
    
    if (index != NSNotFound)
    {
        [self.pictureView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
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
    UBPictureBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.picture = [self.pictures objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 这里启动预加载机制
    
    NSArray *visibleItems = [collectionView indexPathsForVisibleItems];
    
    if (indexPath.row - 1 >= 0 && ![visibleItems containsObject:[NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0]])
    {
        UBPictureBrowsePicture *picture = [self.pictures objectAtIndex:(indexPath.row - 1)];
        
        if ([picture isKindOfClass:[UBPictureBrowseURLPicture class]])
        {
            [self.accessoryDownloader downloadPicture:(UBPictureBrowseURLPicture *)picture];
        }
    }
    
    if (indexPath.row + 1 <= self.pictures.count - 1 && ![visibleItems containsObject:[NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0]])
    {
        UBPictureBrowsePicture *picture = [self.pictures objectAtIndex:(indexPath.row + 1)];
        
        if ([picture isKindOfClass:[UBPictureBrowseURLPicture class]])
        {
            [self.accessoryDownloader downloadPicture:(UBPictureBrowseURLPicture *)picture];
        }
    }
}

- (void)pictureBrowseToolBar:(UBPictureBrowseToolBar *)toolBar didSelectItem:(UBPictureBrowseToolBarItem *)item
{
    
}

@end
