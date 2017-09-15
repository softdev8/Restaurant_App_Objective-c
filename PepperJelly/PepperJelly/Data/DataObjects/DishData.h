//
//  DishData.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import "CommentData.h"
#import "DishImageData.h"

@interface DishData : NSObject

@property (nonatomic, strong) NSString *_id;
//@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSString *placeId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *motive;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *like;
@property (nonatomic, strong) NSNumber *$skip;
@property (nonatomic, strong) NSNumber *$limit;
@property (nonatomic, strong) NSNumber *currentUserLike;
@property (nonatomic, strong) UserData *user;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableArray *image;
@property (nonatomic, strong) NSNumber *rating;

@end
