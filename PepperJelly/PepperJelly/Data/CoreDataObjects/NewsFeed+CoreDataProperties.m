//
//  NewsFeed+CoreDataProperties.m
//  PepperJelly
//
//  Created by Sean McCue on 7/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NewsFeed+CoreDataProperties.h"
#import "DishImage.h"

@implementation NewsFeed (CoreDataProperties)

@dynamic newsFeedId;
@dynamic userId;
@dynamic relatedUser;
@dynamic relatedDish;
@dynamic userAlias;
@dynamic userPhoto;
@dynamic message;
@dynamic type;
@dynamic seen;
@dynamic createdAt;
@dynamic followBack;
@dynamic images;

@end
