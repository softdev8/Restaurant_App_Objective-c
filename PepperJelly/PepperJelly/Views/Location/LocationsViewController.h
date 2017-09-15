//
//  LocationsViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface LocationsViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary *selectedLocation;
@property (nonatomic, assign) BOOL showRecentLocations;
@property (nonatomic, assign) BOOL enteredFromSubmitReview;
@end
