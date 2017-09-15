//
//  Dish.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, User, DishData;

NS_ASSUME_NONNULL_BEGIN

@interface Dish : NSManagedObject

+(Dish *)dishWithId:(NSString *)dishId;
+(Dish *)createWithId:(NSString *)dishId;
+(Dish *)dishWithDishData:(DishData *)dishData;
+(NSArray *)dishesWithRestaurantId:(NSString *)restaurantId;
+(NSArray *)getAll;

-(void)clearComments;
-(void)clearImages;

-(NSString*)mediumImageUrl;
-(NSString*)thumbImageUrl;
-(NSString*)bigImageUrl;

@end

NS_ASSUME_NONNULL_END

#import "Dish+CoreDataProperties.h"
