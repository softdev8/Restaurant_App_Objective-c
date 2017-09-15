//
//  Restaurant+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Restaurant.h"

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *restaurantId;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSNumber *averageRating;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *saved;
@property (nullable, nonatomic, retain) NSNumber *visitCounts;
@property (nullable, nonatomic, retain) NSNumber *didShowViewCountPopup;
@property (nullable, nonatomic, retain) NSString *safeName;
@property (nullable, nonatomic, retain) NSString *placesId;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *menu;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *marketingBanner;
@property (nullable, nonatomic, retain) NSSet<OpeningTime *> *openingTimes;
@property (nullable, nonatomic, retain) NSSet<RestaurantCategory *> *categories;

@end

@interface Restaurant (CoreDataGeneratedAccessors)

- (void)addOpeningTimesObject:(OpeningTime *)value;
- (void)removeOpeningTimesObject:(OpeningTime *)value;
- (void)addOpeningTimes:(NSSet<OpeningTime *> *)values;
- (void)removeOpeningTimes:(NSSet<OpeningTime *> *)values;

- (void)addCategoriesObject:(RestaurantCategory *)value;
- (void)removeCategoriesObject:(RestaurantCategory *)value;
- (void)addCategories:(NSSet<RestaurantCategory *> *)values;
- (void)removeCategories:(NSSet<RestaurantCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
