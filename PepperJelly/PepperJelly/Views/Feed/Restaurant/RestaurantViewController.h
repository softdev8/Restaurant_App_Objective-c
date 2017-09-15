//
//  SingleViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "Restaurant.h"

@interface RestaurantViewController : UITableViewController

@property (nonatomic, strong) Dish *dish;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, strong) NSMutableArray *restaurantDishes;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *mapImage;



@end
