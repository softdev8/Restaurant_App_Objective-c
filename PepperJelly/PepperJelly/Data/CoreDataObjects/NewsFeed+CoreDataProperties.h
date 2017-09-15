//
//  NewsFeed+CoreDataProperties.h
//  PepperJelly
//
//  Created by Sean McCue on 7/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NewsFeed.h"

NS_ASSUME_NONNULL_BEGIN

@class DishImage;

@interface NewsFeed (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *newsFeedId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *relatedUser;
@property (nullable, nonatomic, retain) NSString *relatedDish;
@property (nullable, nonatomic, retain) NSString *userAlias;
@property (nullable, nonatomic, retain) NSString *userPhoto;
@property (nullable, nonatomic, retain) NSString *message;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSNumber *seen;
@property (nullable, nonatomic, retain) NSString *createdAt;
@property (nullable, nonatomic, retain) NSNumber *followBack;
@property (nullable, nonatomic, retain) NSSet<DishImage *> *images;

@end

@interface NewsFeed (CoreDataGeneratedAccessors)

- (void)addImagesObject:(DishImage *)value;
- (void)removeImagesObject:(DishImage *)value;
- (void)addImages:(NSSet<DishImage *> *)values;
- (void)removeImages:(NSSet<DishImage *> *)values;

@end

NS_ASSUME_NONNULL_END
