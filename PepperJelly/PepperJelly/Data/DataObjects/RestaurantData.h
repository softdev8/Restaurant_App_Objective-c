//
//  RestaurantData.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantData : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *visitCounts;
@property (nonatomic, strong) NSString *safeName;
@property (nonatomic, strong) NSString *placesId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *menu;
@property (nonatomic, strong) NSMutableArray *openingTimes;
@property (nonatomic, strong) NSMutableArray *location;
@property (nonatomic, strong) NSNumber *averageRating;
@property (nonatomic, strong) id category;
@property (nonatomic, strong) NSString *marketingBanner; // 
@end
