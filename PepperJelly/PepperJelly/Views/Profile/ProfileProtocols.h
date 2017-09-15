//
//  ProfileDelegate.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, Dish, Restaurant;

@protocol ProfileDelegate <NSObject>

@optional
-(void)openUploadedPhoto:(Dish*)dish;
-(void)openLikedPhoto:(Dish*)dish;
-(void)openRestaurant:(Restaurant*)restaurant;
-(void)openPublish;
-(void)didSelectUser:(User*)user;
-(void)followUser:(User*)user;
-(void)unfollowUser:(User*)user;

@end
