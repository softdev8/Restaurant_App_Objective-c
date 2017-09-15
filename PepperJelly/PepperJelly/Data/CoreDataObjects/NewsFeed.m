//
//  NewsFeed.m
//  PepperJelly
//
//  Created by Sean McCue on 7/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "NewsFeed.h"
#import "CDHelper.h"
#import "DishImage.h"
#import "DishImageData.h"

@implementation NewsFeed

+(NewsFeed *)newsFeedWithId:(NSString *)newsFeedId{
    NSArray *newsFeeds = [CDHelper list:@"NewsFeed" sort:@"" ascending:YES];
    
    for(NewsFeed *newsFeed in newsFeeds)
        if([newsFeed.newsFeedId isEqualToString:newsFeedId])
            return newsFeed;
    
    return nil;
}

+(NewsFeed *)createWithId:(NSString *)newsFeedId{
    NewsFeed *newsFeed = [self newsFeedWithId:newsFeedId];
    
    if(newsFeed)
        return newsFeed;
    
    newsFeed = [CDHelper insert:@"NewsFeed"];
    newsFeed.newsFeedId = newsFeedId;
    return newsFeed;
}

+(NewsFeed*)newsFeedWithNewsFeedData:(NewsFeedData*)newsFeedData{
    NewsFeed *newsFeed = [self createWithId:newsFeedData.newsFeedId];
    newsFeed.userId = newsFeedData.userId;
    newsFeed.followBack = newsFeedData.followBack;
    newsFeed.relatedUser = newsFeedData.relatedUser;
    newsFeed.relatedDish = newsFeedData.relatedDish;
    newsFeed.userAlias = newsFeedData.userAlias;
    newsFeed.userPhoto = newsFeedData.userPhoto;
    newsFeed.message = newsFeedData.message;
    newsFeed.type = newsFeedData.type;
    newsFeed.seen = newsFeedData.seen;
    newsFeed.createdAt = newsFeedData.createdAt;
    
    [newsFeed clearImages];
    if(newsFeedData.dishPhoto && [newsFeedData.dishPhoto isKindOfClass:[NSArray class]]){
        for(DishImageData *imageData in newsFeedData.dishPhoto){
            DishImage *image = [CDHelper insert:@"DishImage"];
            image.url = imageData.url;
            image.width = imageData.width;
            image.height = imageData.height;
            image.newsFeed = newsFeed;
            [newsFeed addImagesObject:image];
        }
    }
    
    return newsFeed;
}

+(NSArray *)getAll{
    return [CDHelper list:@"NewsFeed" sort:@"createdAt" ascending:NO];
}

+(void)clearNewsFeedCompletion:(void(^)(BOOL done))completion{
    NSArray *newsSearches = [CDHelper list:@"NewsFeed" sort:@"createdAt" ascending:NO];
    for(NewsFeed *newsSearch in newsSearches){
        [CDHelper deleteObject:newsSearch];
    }
    
    completion(true);
}

-(void)clearImages{
    [[self mutableSetValueForKey:@"images"] removeAllObjects];
}

-(NSString *)thumbImageUrl{
    NSString *url = @"";
    
    NSArray *images = [CDHelper sortArray:[self.images allObjects] by:@"width" ascending:YES];
    if(images.count > 0)
        url = (NSString*)[[images firstObject] url];
    
    return url;
}

-(NSString *)bigImageUrl{
    NSString *url = @"";
    
    NSArray *images = [CDHelper sortArray:[self.images allObjects] by:@"width" ascending:YES];
    
    //for iPhone6+, it will get the biggest image
    if(images.count > 1 && [[UIScreen mainScreen] bounds].size.width <= 375){
        url = (NSString*)[[images objectAtIndex:1] url];
    }else if(images.count > 0){
        if([[UIScreen mainScreen] bounds].size.width < 375 && images.count > 1)
            url = (NSString*)[[images objectAtIndex:1] url];
        else
            url = (NSString*)[[images lastObject] url];
    }

    return url;
}

@end
