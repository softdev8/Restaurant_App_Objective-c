//
//  Comment+CoreDataProperties.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Comment+CoreDataProperties.h"
#import "Dish.h"

@implementation Comment (CoreDataProperties)

@dynamic commentId;
@dynamic comment;
@dynamic dishId;
@dynamic userId;
@dynamic userName;
@dynamic timeStamp;
@dynamic dish;

@end
