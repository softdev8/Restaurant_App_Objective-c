//
//  PublishViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PublishViewController.h"
#import "DesignableButton.h"
#import "UIView+Loading.h"
#import "PublishPostViewController.h"
#import <Photos/Photos.h>
#import "PublishGalleryCollectionViewCell.h"
#import "PublishCameraCollectionViewCell.h"
#import "ImageCollectionViewController.h"
#import "GooglePlace.h"
#import "Constants.h"
#import "ImageCropViewController.h"
#import "TOCropViewController.h"
#import "PublishCameraViewController.h"

@interface PublishViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, PublishDelegate, ImageCollectionDelegate, ImageCropDelegate, TOCropViewControllerDelegate>{
    BOOL shouldHideStatusBar;
    BOOL isDragging;
    BOOL libraryPermited;
    BOOL cameraPermited;
}

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleArrow;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (strong, nonatomic) PHFetchResult *allPhotosResult;
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //disables so we can enable it in the child scrollviews
    self.collectionView.scrollsToTop = false;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
        cameraPermited = true;
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        libraryPermited = true;
        [self fetchPhotos];
        [self.collectionView reloadData];
    }else if (status == PHAuthorizationStatusDenied) {
        
    }else if (status == PHAuthorizationStatusRestricted) {
        
    }else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                libraryPermited = true;
                [self fetchPhotos];
                self.collectionView.contentOffset = CGPointMake(-10, self.collectionView.contentOffset.y);
                //[self updateTabSelectionWithButton:self.libraryButton shouldScroll:true];
            }else {
                
            }
        }];
    }
}

-(void)setSelectedCollection:(NSString *)selectedCollection{
    [self.titleLabel setText:selectedCollection];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = YES;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.titleView.frame.size.width/2, self.titleView.frame.size.height/2);
}

- (BOOL)prefersStatusBarHidden {
    return shouldHideStatusBar;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[PublishPostViewController class]]){
        ((PublishPostViewController*)segue.destinationViewController).postImage = self.selectedImage;
    }else if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationController = segue.destinationViewController;
        if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[ImageCollectionViewController class]]){
            ((ImageCollectionViewController*)[navigationController.viewControllers objectAtIndex:0]).delegate = self;
        }
    }else if([segue.destinationViewController isKindOfClass:[ImageCropViewController class]]){
        ((ImageCropViewController*)segue.destinationViewController).image = self.selectedImage;
        ((ImageCropViewController*)segue.destinationViewController).delegate = self;
    }else if([segue.destinationViewController isKindOfClass:[PublishCameraViewController class]]){
        ((PublishCameraViewController*)segue.destinationViewController).delegate = self;
    }
}

#pragma mark - Events

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)nextButtonPressed:(id)sender {
    //[self performSegueWithIdentifier:@"imageCropSegue" sender:self];
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:self.selectedImage];
    cropViewController.delegate = self;
    //cropViewController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
    //cropViewController.aspectRatioLocked = true;
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (IBAction)titleButtonPressed:(id)sender {
}

- (IBAction)pictureButtonPressed:(id)sender {
    //[self updateTabSelectionWithButton:sender shouldScroll:true];
}

- (IBAction)libraryButtonPressed:(id)sender {
    //[self updateTabSelectionWithButton:sender shouldScroll:true];
}

//-(void)updateTabSelectionWithButton:(UIButton*)button shouldScroll:(BOOL)shouldScroll{
//    if (button == self.libraryButton){
//        self.libraryButton.selected = true;
//        self.pictureButton.selected = false;
//        if(shouldScroll){
//            [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showNavigationBar) userInfo:nil repeats:NO];
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft|UICollectionViewScrollPositionTop animated:YES];
//        }else{
//            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(showNavigationBar) userInfo:nil repeats:NO];
//        }
//    }else{
//        self.pictureButton.selected = true;
//        self.libraryButton.selected = false;
//        if(shouldScroll){
//            [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft|UICollectionViewScrollPositionTop animated:YES];
//        }else{
//            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(hideNavigationBar) userInfo:nil repeats:NO];
//        }
//    }
//}

-(void)hideNavigationBar{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus != AVAuthorizationStatusAuthorized && !cameraPermited) {
        return;
    }
    
    shouldHideStatusBar = true;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:true animated:true];
    
    if(SYSTEM_VERSION_LESS_THAN(@"9")){
        self.collectionView.translatesAutoresizingMaskIntoConstraints = YES;
        self.collectionView.frame = CGRectMake(0, -10, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
}

-(void)showNavigationBar{
    shouldHideStatusBar = false;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    if(SYSTEM_VERSION_LESS_THAN(@"9")){
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    }
}

-(IBAction)unwindToPublish:(id)sender{

}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == 0){
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized || libraryPermited) {
            PublishGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gallery" forIndexPath:indexPath];
            [cell configWithPhotosResult:self.allPhotosResult delegate:self];
            return cell;
        }else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"galleryDenied" forIndexPath:indexPath];
            return cell;
        }
//    }else{
//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if(authStatus == AVAuthorizationStatusAuthorized || cameraPermited) {
//            PublishCameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"camera" forIndexPath:indexPath];
//            [cell configWithDelegate:self];
//            return cell;
//        } else if(authStatus == AVAuthorizationStatusNotDetermined){
//            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//                cameraPermited = true;
//                [self.collectionView reloadData];
//                self.collectionView.contentOffset = CGPointMake(self.collectionView.contentSize.width+10, self.collectionView.contentOffset.y);
//                [self updateTabSelectionWithButton:self.pictureButton shouldScroll:true];
//            }];
//            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraDenied" forIndexPath:indexPath];
//            return cell;
//        }else{
//            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraDenied" forIndexPath:indexPath];
//            return cell;
//        }
//    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height-64);
    else{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized || cameraPermited) {
            return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
        }
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height-64);
    }
}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    isDragging = true;
//}
//
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    isDragging = false;
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(!isDragging)
//        return;
//    
//    int currentPage = ((self.collectionView.contentOffset.x+self.collectionView.frame.size.width/2) / self.collectionView.frame.size.width);
//    
//    if(currentPage == 0)
//        [self updateTabSelectionWithButton:self.libraryButton shouldScroll:false];
//    else
//        [self updateTabSelectionWithButton:self.pictureButton shouldScroll:false];
//}

#pragma mark - Publish Delegate

-(void)selectImageFromGallery:(UIImage *)image{
    self.selectedImage = image;
}

-(void)selectImageFromCamera:(UIImage *)image{
    self.selectedImage = image;
    [self nextButtonPressed:self.nextButton];
}

-(void)canceledFromCamera{
    [self closeButtonPressed:self];
}

#pragma mark - ImageCollection Delegate

-(void)collectionSelected:(PHAssetCollection *)collection{
    self.assetCollection = collection;
    [self fetchPhotos];
}

#pragma mark - ImageCrop Delegate

-(void)finishedCroppingImage:(UIImage *)image{
    self.selectedImage = image;
    [self performSegueWithIdentifier:@"uploadSegue" sender:self];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    [cropViewController dismissViewControllerAnimated:true completion:^{
        self.selectedImage = image;
        [self performSegueWithIdentifier:@"uploadSegue" sender:self];
    }];
}

#pragma mark - Photos

-(void)fetchPhotos{
    if(self.assetCollection){
        [self setSelectedCollection:self.assetCollection.localizedTitle];
        
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        self.allPhotosResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:fetchOptions];
    }else{
        [self setSelectedCollection:NSLocalizedString(@"all_photos", @"")];
        
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        self.allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    }
    
    [self.collectionView reloadData];
    
    //comes back to fetch photos if has no results, meaning it may not have been granted the permission.
    if(self.allPhotosResult.count == 0)
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fetchPhotos) userInfo:nil repeats:NO];
}

@end
