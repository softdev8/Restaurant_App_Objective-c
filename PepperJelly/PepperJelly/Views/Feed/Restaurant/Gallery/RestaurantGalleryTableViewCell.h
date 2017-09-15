//
//  SingleGalleryTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantProtocols.h"

#define singleGalleryItems 3
#define singleGallerySpacing 1.5

@interface RestaurantGalleryTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) id<RestaurantDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *dishes;

-(void)configWithDishes:(NSArray*)dishes;

@end
