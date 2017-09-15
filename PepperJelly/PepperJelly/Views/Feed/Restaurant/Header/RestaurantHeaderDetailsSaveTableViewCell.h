//
//  RestaurantHeaderDetailsSaveTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"
#import "RestaurantProtocols.h"

@interface RestaurantHeaderDetailsSaveTableViewCell : UITableViewCell

@property (weak, nonatomic) id<RestaurantDelegate> delegate;

@property (weak, nonatomic) IBOutlet DesignableButton *saveButton;

@end
