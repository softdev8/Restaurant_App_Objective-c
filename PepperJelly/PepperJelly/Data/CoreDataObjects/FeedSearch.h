//
//  FeedSearch.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/10/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dish;

NS_ASSUME_NONNULL_BEGIN

@interface FeedSearch : NSManagedObject

+(FeedSearch*)lastFeedSearchWithFollowing:(BOOL)following;
+(void)saveFeedSearchWithDishes:(NSArray*)dishes following:(BOOL)following;
+(NSArray *)getDishesFromLastSearchWithFollowing:(BOOL)following;
+(void)clearSearches;

-(void)clearDishes;

@end

NS_ASSUME_NONNULL_END

#import "FeedSearch+CoreDataProperties.h"
