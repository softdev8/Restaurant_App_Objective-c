//
//  Restaurant.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "Restaurant.h"
#import "RestaurantCategory.h"
#import "OpeningTime.h"
#import "CDHelper.h"
#import "RestaurantData.h"

@implementation Restaurant

+(Restaurant *)restaurantWithId:(NSString *)restaurantId{
    NSArray *restaurants = [CDHelper list:@"Restaurant" sort:@"" ascending:YES];
    
    for(Restaurant *restaurant in restaurants)
        if([restaurant.restaurantId isEqualToString:restaurantId])
            return restaurant;
    return nil;
}

+(Restaurant *)restaurantWithRestaurantData:(RestaurantData *)restaurantData{
    Restaurant *restaurant = [self createWithId:restaurantData._id];
    
    NSLog(@"DEBUG CHECKING RATING: %@", restaurantData.averageRating);
    
    if([restaurantData.marketingBanner isKindOfClass:[NSString class]]){
        restaurant.marketingBanner = restaurantData.marketingBanner;
    }else{
        restaurant.marketingBanner = nil;
    }
    if([restaurantData.name isKindOfClass:[NSString class]])
        restaurant.name = restaurantData.name;
    if([restaurantData.safeName isKindOfClass:[NSString class]])
        restaurant.safeName = restaurantData.safeName;
    if([restaurantData.placesId isKindOfClass:[NSString class]])
        restaurant.placesId = restaurantData.placesId;
    if([restaurantData.rating isKindOfClass:[NSNumber class]])
        restaurant.rating = restaurantData.rating;
    if([restaurantData.rating isKindOfClass:[NSNumber class]])
        restaurant.averageRating = restaurantData.averageRating;
    if([restaurantData.userId isKindOfClass:[NSString class]])
        restaurant.userId = restaurantData.userId;
    if([restaurantData.address isKindOfClass:[NSString class]])
        restaurant.address = restaurantData.address;
    if([restaurantData.menu isKindOfClass:[NSString class]])
        restaurant.menu = restaurantData.menu;
    if([restaurantData.phone isKindOfClass:[NSString class]])
        restaurant.phone = restaurantData.phone;
    if([restaurantData.visitCounts isKindOfClass:[NSNumber class]])
        restaurant.visitCounts = restaurantData.visitCounts;
    
    if(![restaurantData.image isKindOfClass:[NSNull class]])
        restaurant.image = restaurantData.image;
    
    if(restaurantData.location && [restaurantData.location respondsToSelector:@selector(count)] && restaurantData.location.count == 2){
        restaurant.latitude = [restaurantData.location objectAtIndex:1];
        restaurant.longitude = [restaurantData.location objectAtIndex:0];
    }
    
    [restaurant clearCategories];
    if(restaurantData.category){
        if([restaurantData.category isKindOfClass:[NSArray class]]){
            int count = 0;
            for(NSString *categoryString in restaurantData.category){
                RestaurantCategory *category = [CDHelper insert:@"RestaurantCategory"];
                category.name = categoryString;
                category.order = [NSNumber numberWithInt:count];
                category.restaurant = restaurant;
                [restaurant addCategoriesObject:category];
                count++;
            }
        }else if([restaurantData.category isKindOfClass:[NSString class]] && ((NSString*)restaurantData.category).length > 0){
            RestaurantCategory *category = [CDHelper insert:@"RestaurantCategory"];
            category.name = restaurantData.category;
            category.restaurant = restaurant;
            [restaurant addCategoriesObject:category];
        }
    }
    
    [restaurant clearOpeningTimes];
    if(restaurantData.openingTimes){
        if([restaurantData.openingTimes isKindOfClass:[NSArray class]]){
            int count = 0;
            for(NSString *timeString in restaurantData.openingTimes){
                OpeningTime *openingTime = [CDHelper insert:@"OpeningTime"];
                openingTime.formatted = timeString;
                openingTime.restaurant = restaurant;
                openingTime.order = [NSNumber numberWithInteger:count];
                count++;
                [restaurant addOpeningTimesObject:openingTime];
                
                NSArray *dayBreak = [timeString componentsSeparatedByString:@": "];
                if(dayBreak.count > 1){
                    openingTime.dayOfWeek = [dayBreak[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    NSArray *hourBreak = [dayBreak[1] componentsSeparatedByString:@"–"];
                    if(hourBreak.count > 1){
                        openingTime.openingTime = [hourBreak[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        openingTime.closingTime = [hourBreak[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                }
            }
        }
    }
    
    return restaurant;
}

+(Restaurant *)createWithId:(NSString *)restaurantId{
    Restaurant *restaurant = [self restaurantWithId:restaurantId];
    NSLog(@"-----restaurant:@", restaurant);
    if(restaurant)
        return restaurant;
    
    restaurant = [CDHelper insert:@"Restaurant"];
    restaurant.restaurantId = restaurantId;
    return restaurant;
}

+(NSArray *)getAll{
    return [CDHelper list:@"Restaurant" sort:@"name" ascending:YES];
}

+(NSArray *)getSaved{
    NSArray *restaurants = [CDHelper list:@"Restaurant" sort:@"name" ascending:YES];
    
    NSMutableArray *saved = [[NSMutableArray alloc] init];
    for(Restaurant *restaurant in restaurants)
        if([restaurant.saved boolValue])
           [saved addObject:restaurant];
    
    return saved;
}

-(void)clearCategories{
    [[self mutableSetValueForKey:@"categories"] removeAllObjects];
}

-(void)clearOpeningTimes{
    [[self mutableSetValueForKey:@"openingTimes"] removeAllObjects];
}

@end
