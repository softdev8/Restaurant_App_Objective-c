//
//  FilterViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface FilterViewController : UIViewController

@property (nonatomic, strong) NSString *selectedAddress;
@property (nonatomic, strong) CLLocation *selectedLocation;
@property (nonatomic, assign) BOOL changeLocationOnOpen;

@end