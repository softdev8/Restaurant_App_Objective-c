//
//  OpeningTime+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "OpeningTime.h"

NS_ASSUME_NONNULL_BEGIN

@class Restaurant;

@interface OpeningTime (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *formatted;
@property (nullable, nonatomic, retain) NSString *dayOfWeek;
@property (nullable, nonatomic, retain) NSString *openingTime;
@property (nullable, nonatomic, retain) NSString *closingTime;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) Restaurant *restaurant;

@end

NS_ASSUME_NONNULL_END
