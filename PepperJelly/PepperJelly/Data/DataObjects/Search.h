//
//  Search.h
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Search : NSObject

@property (nonatomic, strong) NSString *search;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *range;
@property (nonatomic, strong) NSNumber *onlyFollowed;
@property (nonatomic, strong) NSArray *category;
@property (nonatomic, strong) NSNumber *$skip;
@property (nonatomic, strong) NSNumber *$limit;
@property (nonatomic, strong) NSNumber *currentUserLike;
@property (nonatomic, strong) NSString *deviceToken;

-(void)setRangeWithSliderOption:(DistanceSliderOption)option;


@end
