//
//  RestaurantPhotoDetailsTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableImageView.h"
#import "RestaurantPhotoTableViewCell.h"
#import "RestaurantProtocols.h"

@interface RestaurantPhotoDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RestaurantDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet DesignableImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;

@end
