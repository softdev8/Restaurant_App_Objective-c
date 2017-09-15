//
//  User+CoreDataProperties.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/18/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User+CoreDataProperties.h"
#import "Report.h"

@implementation User (CoreDataProperties)

@dynamic fullName;
@dynamic password;
@dynamic email;
@dynamic role;
@dynamic followersCount;
@dynamic followedCount;
@dynamic dishCount;
@dynamic likeCount;
@dynamic restaurants;
@dynamic userId;
@dynamic userName;
@dynamic userImage;
@dynamic locationName;
@dynamic locationRange;
@dynamic locationLatitude;
@dynamic useCustomLocation;
@dynamic locationLongitude;
@dynamic feed;
@dynamic followingUsers;
@dynamic followerUsers;
@dynamic reports;
@dynamic dishes;
@dynamic categories;

@end
