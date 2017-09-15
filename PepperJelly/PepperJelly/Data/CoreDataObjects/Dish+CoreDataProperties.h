//
//  Dish+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dish.h"

NS_ASSUME_NONNULL_BEGIN

@class DishImage;

@interface Dish (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *dishId;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *restaurantId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSNumber *likes;
@property (nullable, nonatomic, retain) NSNumber *currentUserLike;
@property (nullable, nonatomic, retain) User *user;
@property (nullable, nonatomic, retain) NSSet<Comment *> *comments;
@property (nullable, nonatomic, retain) NSSet<DishImage *> *images;

@end

@interface Dish (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet<Comment *> *)values;
- (void)removeComments:(NSSet<Comment *> *)values;

- (void)addImagesObject:(DishImage *)value;
- (void)removeImagesObject:(DishImage *)value;
- (void)addImages:(NSSet<DishImage *> *)values;
- (void)removeImages:(NSSet<DishImage *> *)values;

@end

NS_ASSUME_NONNULL_END
