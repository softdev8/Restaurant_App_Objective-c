//
//  FeedSearch.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/10/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "FeedSearch.h"
#import "Dish.h"
#import "CDHelper.h"

@implementation FeedSearch

+(FeedSearch*)lastFeedSearchWithFollowing:(BOOL)following{
    NSArray *feedSearches = [CDHelper list:@"FeedSearch" sort:@"date" ascending:NO];
    
    for(FeedSearch *feedSearch in feedSearches){
        if(following && [feedSearch.following boolValue])
            return feedSearch;
        else if(!following && ![feedSearch.following boolValue])
            return feedSearch;
    }
    
    return nil;
}

+(void)saveFeedSearchWithDishes:(NSArray*)dishes following:(BOOL)following{
    FeedSearch *feedSearch = [self lastFeedSearchWithFollowing:following];
    
    if(!feedSearch)
        feedSearch = [CDHelper insert:@"FeedSearch"];
    feedSearch.following = [NSNumber numberWithBool:following];
    
    [feedSearch clearDishes];
    for(Dish *dish in dishes)
        [feedSearch addDishesObject:dish];
    feedSearch.date = [NSDate date];
    
    [CDHelper save];
}

+(NSArray *)getDishesFromLastSearchWithFollowing:(BOOL)following{
    FeedSearch *feedSearch = [self lastFeedSearchWithFollowing:following];
    
    if(feedSearch)
        return [CDHelper sortArray:[feedSearch.dishes allObjects] by:@"createdAt" ascending:NO];
    
    return [NSArray new];
}

+(void)clearSearches{
    NSArray *feedSearches = [CDHelper list:@"FeedSearch" sort:@"date" ascending:NO];
    for(FeedSearch *feedSearch in feedSearches)
        [CDHelper deleteObject:feedSearch];
}

-(void)clearDishes{
    [[self mutableSetValueForKey:@"dishes"] removeAllObjects];
}

@end
