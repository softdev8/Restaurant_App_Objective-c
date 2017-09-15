//
//  UploadedPhotoViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "Restaurant.h"

@interface UploadedPhotoViewController : UIViewController

@property (nonatomic, strong) Dish *dish;
@property (nonatomic, strong) Restaurant *restaurant;
@property (nonatomic, assign) BOOL enteredAsPushNavigation;
@end
