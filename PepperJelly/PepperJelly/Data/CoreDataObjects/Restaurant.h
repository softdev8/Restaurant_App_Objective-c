//
//  Restaurant.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RestaurantCategory, OpeningTime, RestaurantData;

NS_ASSUME_NONNULL_BEGIN

@interface Restaurant : NSManagedObject

+(Restaurant*)restaurantWithId:(NSString*)restaurantId;
+(Restaurant*)restaurantWithRestaurantData:(RestaurantData*)restaurantData;
+(Restaurant*)createWithId:(NSString*)restaurantId;
+(NSArray*)getAll;
+(NSArray*)getSaved;

-(void)clearCategories;
-(void)clearOpeningTimes;
-(void)clearAll;

@end

NS_ASSUME_NONNULL_END

#import "Restaurant+CoreDataProperties.h"
