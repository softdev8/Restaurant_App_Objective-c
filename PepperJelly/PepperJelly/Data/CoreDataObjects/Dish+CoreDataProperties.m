//
//  Dish+CoreDataProperties.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dish+CoreDataProperties.h"
#import "DishImage.h"

@implementation Dish (CoreDataProperties)

@dynamic dishId;
@dynamic image;
@dynamic restaurantId;
@dynamic userId;
@dynamic status;
@dynamic createdAt;
@dynamic likes;
@dynamic currentUserLike;
@dynamic user;
@dynamic comments;
@dynamic images;

@end
