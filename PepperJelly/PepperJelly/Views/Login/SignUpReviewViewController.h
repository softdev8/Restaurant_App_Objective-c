//
//  SignUpReviewViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Search.h"
@import CoreLocation;

@interface SignUpReviewViewController : UIViewController

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *selectedAddress;
@property (nonatomic, strong) CLLocation *selectedLocation;
@property (nonatomic, strong) Search *searchOptions;
@end
