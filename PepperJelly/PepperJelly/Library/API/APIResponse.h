//
//  APIResponse.h
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import "RestaurantData.h"
#import "DishData.h"
#import "CategoryItem.h"
#import "GooglePlace.h"
#import "NewsFeedData.h"

@interface APIResponse : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *SERVER_ERROR;
@property (nonatomic, strong) UserData *user;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, strong) NSMutableArray *followers;
@property (nonatomic, strong) NSMutableArray *following;
@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic, strong) NSMutableArray *dishes;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSNumber *follow;
@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *success;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *like;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *googlePlaces;
@property (nonatomic, strong) NSMutableArray *latestActivity;


@end
