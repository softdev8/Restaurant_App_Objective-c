//
//  SinglePhotoTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"
#import "RestaurantProtocols.h"
#import "Dish.h"

@interface RestaurantPhotoTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id<RestaurantDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet DesignableButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (strong, nonatomic) NSArray *dishes;
@property (strong, nonatomic) Dish *dish;
@property (strong, nonatomic) UIImage *selectedImage;
@property (assign, nonatomic) BOOL showPlaceholder;

-(void)configWithDishes:(NSArray *)dishes atPosition:(int)position showPlaceholder:(BOOL)showPlaceholder selectedImage:(UIImage*)selectedImage;

@end
