//
//  UserTest.h
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userBio;
@property (nonatomic, strong) NSString *followedUser;
@property (nonatomic, strong) NSNumber *role;
@property (nonatomic, strong) NSNumber *getReports;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSNumber *userNew;
@property (nonatomic, strong) NSString *googleId;
@property (nonatomic, strong) NSNumber *useCustomLocation;
@property (nonatomic, strong) NSNumber *currentUserLike;
@property (nonatomic, strong) NSNumber *range;
@property (nonatomic, strong) NSArray *location;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSMutableDictionary *profile;
@property (nonatomic, strong) NSMutableDictionary *stats;
@property (nonatomic, strong) NSArray *reports;
@property (nonatomic, strong) NSArray *categories;

-(void)setFullName:(NSString *)name;
-(NSString*)getFullName;

-(void)setEmail:(NSString*)email;
-(NSString*)getEmail;

-(void)setUserBio:(NSString*)userBio;
-(NSString*)getUserBio;

-(void)setFollowers:(NSNumber*)followers;
-(NSNumber*)getFollowers;

-(void)setFollowed:(NSNumber*)followed;
-(NSNumber*)getFollowed;

-(void)setDishes:(NSNumber*)dishes;
-(NSNumber*)getDishes;

-(void)setLikes:(NSNumber*)likes;
-(NSNumber*)getLikes;

-(void)setRestaurants:(NSNumber*)restaurants;
-(NSNumber*)getRestaurants;

-(void)setPictures:(NSArray*)pictures;
-(NSArray*)getPictures;
-(NSString*)getPicture;

@end
