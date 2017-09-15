//
//  RestaurantMapTableViewCell.h
//  PepperJelly
//
//  Created by Peter Simpson on 9/23/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Restaurant.h"

@interface RestaurantMapTableViewCell : UITableViewCell

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIImageView *mapImage;
@property (nonatomic, strong) Restaurant *restaurant;

@end
