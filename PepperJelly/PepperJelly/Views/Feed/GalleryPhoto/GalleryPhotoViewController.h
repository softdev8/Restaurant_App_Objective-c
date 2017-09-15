//
//  GalleryPhotoViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "Restaurant.h"

@interface GalleryPhotoViewController : UIViewController

@property (nonatomic, strong) Dish *dish;
@property (nonnull, strong) Restaurant *restaurant;
@end
