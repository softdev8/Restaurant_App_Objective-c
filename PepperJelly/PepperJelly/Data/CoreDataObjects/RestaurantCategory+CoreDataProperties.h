//
//  RestaurantCategory+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/26/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RestaurantCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) Restaurant *restaurant;

@end

NS_ASSUME_NONNULL_END
