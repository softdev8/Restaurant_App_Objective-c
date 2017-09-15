//
//  UploadedDescriptionTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"

@protocol UploadedDescriptionDelegate <NSObject>
@optional
-(void)openRestaurant;

@end

@interface UploadedDescriptionTableViewCell : UITableViewCell

@property (nonatomic, weak) id<UploadedDescriptionDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DesignableButton *restaurantButton;

@end
