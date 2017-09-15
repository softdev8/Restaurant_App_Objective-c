//
//  AddResaurantViewController.h
//  PepperJelly
//
//  Created by Sean McCue on 4/22/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GooglePlace.h"

@interface AddRestaurantViewController : UITableViewController
@property (nonatomic, strong) GooglePlace *selectedRestaurant;

@end
