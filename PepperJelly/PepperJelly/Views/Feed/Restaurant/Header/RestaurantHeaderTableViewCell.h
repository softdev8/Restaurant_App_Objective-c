//
//  SingleHeaderTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PepperJelly-Swift.h" // Imports all swift files
#import <UIKit/UIKit.h>
#import "DesignableView.h"
#import "RestaurantProtocols.h"

@interface RestaurantHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RestaurantDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;
@property (weak, nonatomic) IBOutlet UILabel *viewsCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *viewsCountImageView;
@property (weak, nonatomic) IBOutlet CosmosView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
