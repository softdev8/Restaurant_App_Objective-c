//
//  FeedSearch+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/10/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FeedSearch.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedSearch (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *following;
@property (nullable, nonatomic, retain) NSSet<Dish *> *dishes;

@end

@interface FeedSearch (CoreDataGeneratedAccessors)

- (void)addDishesObject:(Dish *)value;
- (void)removeDishesObject:(Dish *)value;
- (void)addDishes:(NSSet<Dish *> *)values;
- (void)removeDishes:(NSSet<Dish *> *)values;

@end

NS_ASSUME_NONNULL_END
