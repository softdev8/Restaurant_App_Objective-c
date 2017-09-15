//
//  PublishGalleryCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PublishGalleryCollectionViewCell.h"
#import "PublishPhotoCollectionViewCell.h"
#import "UIView+Loading.h"
#import "Constants.h"

@implementation PublishGalleryCollectionViewCell

-(void)awakeFromNib{
    //enable to scrolltotop when tap on statusbar
    self.collectionView.scrollsToTop = true;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.selectedPhotoImageView.layer.masksToBounds = true;
}

-(void)configWithPhotosResult:(PHFetchResult *)photosResult delegate:(id)delegate{
    self.selectedPhotoImageView.image = PJ_IMAGE_PLACEHOLDER;
    
    self.allPhotosResult = photosResult;
    self.delegate = delegate;
    [self.collectionView reloadData];
    
    if(self.allPhotosResult.count > 0)
        [self selectPhoto:[self.allPhotosResult objectAtIndex:0] size:CGSizeMake(self.selectedPhotoImageView.frame.size.width*[UIScreen mainScreen].scale, self.selectedPhotoImageView.frame.size.height*[UIScreen mainScreen].scale) completion:nil];
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allPhotosResult.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PublishPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.photoImageView.layer.masksToBounds = true;
    
    //gets image accorind to scale
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    CGSize size = CGSizeMake([self getCellSize]*[UIScreen mainScreen].scale, [self getCellSize]*[UIScreen mainScreen].scale);
    [[PHImageManager defaultManager] requestImageForAsset:[self.allPhotosResult objectAtIndex:indexPath.row] targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.photoImageView.image = result;
        /*
        PublishPhotoCollectionViewCell *updateCell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
        if(updateCell)
            updateCell.photoImageView.image = result;
         */
    }];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float size = [self getCellSize];
    return CGSizeMake(size, size);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //gets retina image
    [self selectPhoto:[self.allPhotosResult objectAtIndex:indexPath.row] size:CGSizeMake(self.selectedPhotoImageView.frame.size.width*[UIScreen mainScreen].scale, self.selectedPhotoImageView.frame.size.height*[UIScreen mainScreen].scale) completion:nil];
}

-(float)getCellSize{
    return [[UIScreen mainScreen] bounds].size.width/photoGalleryItems-(photoGallerySpacing*(photoGalleryItems-1));
}

#pragma mark - Photos

-(void)selectPhoto:(PHAsset*)asset size:(CGSize)size completion:(void (^)(BOOL success, id obj))completion{
    [self.selectedPhotoImageView startAnimating];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;

    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        [self.selectedPhotoImageView stopAnimating];
        self.selectedPhotoImageView.image = result;
        
        [self.delegate selectImageFromGallery:result];
    }];
}


@end
