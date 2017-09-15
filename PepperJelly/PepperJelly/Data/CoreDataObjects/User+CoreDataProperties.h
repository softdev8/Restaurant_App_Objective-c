//
//  User+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/18/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@class Report, Dish, FeedSearch, UserCategory;

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *userBio;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *role;
@property (nullable, nonatomic, retain) NSNumber *followersCount;
@property (nullable, nonatomic, retain) NSNumber *followedCount;
@property (nullable, nonatomic, retain) NSNumber *dishCount;
@property (nullable, nonatomic, retain) NSNumber *likeCount;
@property (nullable, nonatomic, retain) NSNumber *restaurants;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *userImage;
@property (nullable, nonatomic, retain) NSNumber *locationRange;
@property (nullable, nonatomic, retain) NSString *locationName;
@property (nullable, nonatomic, retain) NSNumber *locationLongitude;
@property (nullable, nonatomic, retain) NSNumber *locationLatitude;
@property (nullable, nonatomic, retain) NSNumber *useCustomLocation;
@property (nullable, nonatomic, retain) FeedSearch *feed;
@property (nullable, nonatomic, retain) NSSet<User *> *followingUsers;
@property (nullable, nonatomic, retain) NSSet<User *> *followerUsers;
@property (nullable, nonatomic, retain) NSSet<Report *> *reports;
@property (nullable, nonatomic, retain) NSSet<Dish *> *dishes;
@property (nullable, nonatomic, retain) NSSet<UserCategory *> *categories;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFollowingUsersObject:(User *)value;
- (void)removeFollowingUsersObject:(User *)value;
- (void)addFollowingUsers:(NSSet<User *> *)values;
- (void)removeFollowingUsers:(NSSet<User *> *)values;

- (void)addFollowerUsersObject:(User *)value;
- (void)removeFollowerUsersObject:(User *)value;
- (void)addFollowerUsers:(NSSet<User *> *)values;
- (void)removeFollowerUsers:(NSSet<User *> *)values;

- (void)addReportsObject:(Report *)value;
- (void)removeReportsObject:(Report *)value;
- (void)addReports:(NSSet<Report *> *)values;
- (void)removeReports:(NSSet<Report *> *)values;

- (void)addDishesObject:(Dish *)value;
- (void)removeDishesObject:(Dish *)value;
- (void)addDishes:(NSSet<Dish *> *)values;
- (void)removeDishes:(NSSet<Dish *> *)values;

- (void)addCategoriesObject:(UserCategory *)value;
- (void)removeCategoriesObject:(UserCategory *)value;
- (void)addCategories:(NSSet<UserCategory *> *)values;
- (void)removeCategories:(NSSet<UserCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
