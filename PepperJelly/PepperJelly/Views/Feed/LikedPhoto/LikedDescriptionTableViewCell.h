//
//  LikedDescriptionTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableImageView.h"
#import "DesignableButton.h"

@protocol LikedDescriptionDelegate <NSObject>
@optional
-(void)openRestaurant;

@end

@interface LikedDescriptionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LikedDescriptionDelegate> delegate;

@property (weak, nonatomic) IBOutlet DesignableImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DesignableButton *restaurantButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@end
