//
//  PublishGalleryCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "PublishProtocols.h"

#define photoGalleryItems 4
#define photoGallerySpacing 1

@interface PublishGalleryCollectionViewCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<PublishDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedPhotoImageView;

@property (strong, nonatomic) PHFetchResult *allPhotosResult;

-(void)configWithPhotosResult:(PHFetchResult*)photosResult delegate:(id)delegate;

@end
