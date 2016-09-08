//
//  UBPicturePickerActionSheetScene.m
//  FrameworkV1
//
//  Created by ww on 16/6/8.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBPicturePickerActionSheetScene.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "UBListingPicturePickerViewController.h"

@interface UBPicturePickerActionSheetScene () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UBListingPicturePickerViewControllerDelegate>

@property (nonatomic) UIAlertController *alertController;

@property (nonatomic) UIViewController *pickerController;

@property (nonatomic) UBPicturePickerAction *selectedAction;

- (void)didSelectAction:(UBPicturePickerAction *)action;

- (void)showPhotoLibrary;

- (void)showCamera;

- (void)showSavedPhotosAlbum;

- (void)showPictureList;

- (void)finishWithError:(NSError *)error pickedImages:(NSArray<UBPicturePickerPickedImage *> *)images;

@end


@implementation UBPicturePickerActionSheetScene

- (void)dealloc
{
    // 为防止alertController显示时，scene被撤销而可能导致alertController一直被显示，这里需要进行一次dismiss操作
    if (self.alertController && self.alertController.presentingViewController)
    {
        [self.alertController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    // 为防止pickerController显示时，scene被撤销而可能导致pickerController一直被显示，这里需要进行一次dismiss操作
    if (self.pickerController && self.pickerController.presentingViewController)
    {
        [self.pickerController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)start
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UBPicturePickerAction *action in self.actions)
    {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:action.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull alertAction) {
            
            [weakSelf didSelectAction:action];
        }];
        
        [alertController addAction:alertAction];
    }
    
    self.alertController = alertController;
    
    [self.navigationController.topViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)didSelectAction:(UBPicturePickerAction *)action
{
    self.selectedAction = action;
    
    // 在这里需要判断权限
    if ([action.actionId isEqualToString:kPicturePickerActionId_Cancel])
    {
        [self finishWithError:nil pickedImages:nil];
    }
    else if ([action.actionId isEqualToString:kPicturePickerActionId_PhotoLibrary])
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        switch (status)
        {
            case PHAuthorizationStatusRestricted:
                
            case PHAuthorizationStatusDenied:
                
                NSLog(@"");
                
                break;
                
            case PHAuthorizationStatusNotDetermined:
            {
                __weak typeof(self) weakSelf = self;
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        [weakSelf showPhotoLibrary];
                    }
                    else
                    {
                        NSLog(@"");
                    }
                }];
                
                break;
            }
                
            case PHAuthorizationStatusAuthorized:
                
                [self showPhotoLibrary];
                
                break;
                
            default:
                
                break;
        }
    }
    else if ([action.actionId isEqualToString:kPicturePickerActionId_Camera])
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status)
        {
            case AVAuthorizationStatusRestricted:
                
            case AVAuthorizationStatusDenied:
                
                NSLog(@"");
                
                break;
                
            case AVAuthorizationStatusNotDetermined:
            {
                __weak typeof(self) weakSelf = self;
                
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    if (granted)
                    {
                        [weakSelf showCamera];
                    }
                }];
            }
                
            case AVAuthorizationStatusAuthorized:
                
                [self showCamera];
                
                break;
                
            default:
                break;
        }
    }
    else if ([action.actionId isEqualToString:kPicturePickerActionId_SavedPhotosAlbum])
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        switch (status)
        {
            case PHAuthorizationStatusRestricted:
                
            case PHAuthorizationStatusDenied:
                
                NSLog(@"");
                
                break;
                
            case PHAuthorizationStatusNotDetermined:
            {
                __weak typeof(self) weakSelf = self;
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        [weakSelf showSavedPhotosAlbum];
                    }
                    else
                    {
                        NSLog(@"");
                    }
                }];
                
                break;
            }
                
            case PHAuthorizationStatusAuthorized:
                
                [self showSavedPhotosAlbum];
                
                break;
                
            default:
                
                break;
        }
    }
    else if ([action.actionId isEqualToString:kPicturePickerActionId_PhotoLibraryList])
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        switch (status)
        {
            case PHAuthorizationStatusRestricted:
                
            case PHAuthorizationStatusDenied:
                
                NSLog(@"");
                
                break;
                
            case PHAuthorizationStatusNotDetermined:
            {
                __weak typeof(self) weakSelf = self;
                
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        [weakSelf showPictureList];
                    }
                    else
                    {
                        NSLog(@"");
                    }
                }];
                
                break;
            }
                
            case PHAuthorizationStatusAuthorized:
                
                [self showPictureList];
                
                break;
                
            default:
                
                break;
        }
    }
}

- (void)finishWithError:(NSError *)error pickedImages:(NSArray<UBPicturePickerPickedImage *> *)images
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(picturePickerActionSheetScene:didFinishWithError:pickedImages:)])
    {
        [self.delegate picturePickerActionSheetScene:self didFinishWithError:error pickedImages:images];
    }
}

- (void)showPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        pickerController.delegate = self;
        
        pickerController.allowsEditing = self.selectedAction.enableEditing;
        
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.navigationController.topViewController presentViewController:pickerController animated:YES completion:nil];
        
        self.pickerController = pickerController;
    }
    else
    {
        NSLog(@"");
    }
}

- (void)showCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        pickerController.delegate = self;
        
        pickerController.allowsEditing = self.selectedAction.enableEditing;
        
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.navigationController.topViewController presentViewController:pickerController animated:YES completion:nil];
        
        self.pickerController = pickerController;
    }
    else
    {
        NSLog(@"");
    }
}

- (void)showSavedPhotosAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        
        pickerController.delegate = self;
        
        pickerController.allowsEditing = self.selectedAction.enableEditing;
        
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self.navigationController.topViewController presentViewController:pickerController animated:YES completion:nil];
        
        self.pickerController = pickerController;
    }
    else
    {
        NSLog(@"");
    }
}

- (void)showPictureList
{
    UBListingPicturePickerViewController *pickerController = [[UBListingPicturePickerViewController alloc] initWithNibName:NSStringFromClass([UBListingPicturePickerViewController class]) bundle:nil];
    
    pickerController.delegate = self;
    
    pickerController.enableRemoteImages = YES;
    
    pickerController.allowsMultipleSelection = YES;
    
    [self.navigationController.topViewController presentViewController:pickerController animated:YES completion:nil];
    
    self.pickerController = pickerController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UBPicturePickerPickedImage *pickedImage = [[UBPicturePickerPickedImage alloc] init];
    
    pickedImage.image = picker.allowsEditing ? [info objectForKey:UIImagePickerControllerEditedImage] : [info objectForKey:UIImagePickerControllerOriginalImage];
    
    __weak typeof(self) weakSelf = self;
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        weakSelf.pickerController = nil;
        
        [weakSelf finishWithError:nil pickedImages:[NSArray arrayWithObject:pickedImage]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        weakSelf.pickerController = nil;
        
        [weakSelf finishWithError:nil pickedImages:nil];
    }];
}

- (void)listingPicturePickerViewController:(UBListingPicturePickerViewController *)controller didFinishWithPickedImages:(NSArray<UIImage *> *)images
{
    NSMutableArray<UBPicturePickerPickedImage *> *pickedImages = [[NSMutableArray alloc] init];
    
    for (UIImage *image in images)
    {
        UBPicturePickerPickedImage *pickedImage = [[UBPicturePickerPickedImage alloc] init];
        
        pickedImage.image = image;
        
        [pickedImages addObject:pickedImage];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        weakSelf.pickerController = nil;
        
        [weakSelf finishWithError:nil pickedImages:pickedImages];
    }];
}

@end


@implementation UBPicturePickerAction

+ (UBPicturePickerAction *)actionWithId:(NSString *)actionId title:(NSString *)title
{
    UBPicturePickerAction *action = [[UBPicturePickerAction alloc] init];
    
    action.actionId = actionId ? actionId : @"";
    
    action.title = title ? title : @"";
    
    return action;
}

@end


@implementation UBPicturePickerPickedImage

@end


NSString * const kPicturePickerActionId_Cancel = @"cancel";

NSString * const kPicturePickerActionId_PhotoLibrary = @"photoLibrary";

NSString * const kPicturePickerActionId_Camera = @"camera";

NSString * const kPicturePickerActionId_SavedPhotosAlbum = @"savedPhotosAlbum";

NSString * const kPicturePickerActionId_PhotoLibraryList = @"photoLibraryList";
