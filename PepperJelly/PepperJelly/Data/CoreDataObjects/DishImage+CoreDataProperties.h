//
//  DishImage+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DishImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DishImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSNumber *width;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) Dish *dish;
@property (nullable, nonatomic, retain) NewsFeed *newsFeed;

@end

NS_ASSUME_NONNULL_END
