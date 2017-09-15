//
//  NewsFeedData.h
//  PepperJelly
//
//  Created by Sean McCue on 7/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsFeedData : NSObject
@property (nonatomic, strong) NSString *newsFeedId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *relatedUser;
@property (nonatomic, strong) NSString *relatedDish;
@property (nonatomic, strong) NSString *userAlias;
@property (nonatomic, strong) NSString *userPhoto;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *seen;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSMutableArray *dishPhoto;
@property (nonatomic, strong) NSNumber *followBack;
@end
