//
//  NewsFeed.h
//  PepperJelly
//
//  Created by Sean McCue on 7/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewsFeedData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsFeed : NSManagedObject

+(NewsFeed*)newsFeedWithNewsFeedData:(NewsFeedData*)newsFeedData;

+(NewsFeed *)newsFeedWithId:(NSString *)newsFeedId;
+(NewsFeed *)createWithId:(NSString *)newsFeedId;
+(NSArray *)getAll;
+(void)clearNewsFeedCompletion:(void(^)(BOOL done))completion;

-(void)clearImages;
-(NSString *)thumbImageUrl;
-(NSString *)bigImageUrl;

@end

NS_ASSUME_NONNULL_END

#import "NewsFeed+CoreDataProperties.h"
