//
//  UserModify.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/19/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserModify : NSObject

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *userBio;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *location;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, assign) BOOL useCustomLocation;
@property (nonatomic, strong) NSNumber *range;

-(id)initWithUser:(User*)user;

-(void)setLatitude:(double)latitude andLongitude:(double)longitude;

@end
