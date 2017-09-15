//
//  APIResponse.m
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "APIResponse.h"

@implementation APIResponse

-(void)setUser:(NSDictionary *)user{
    _user = [[UserData alloc] init];
    if(![user isKindOfClass:[NSNull class]]){
        [user enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([UserData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [_user setValue:value forKey:key];
            }
        }];
    }
}

-(void)setUsers:(NSMutableArray *)users{
    _users = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in users) {
        UserData *obj = [[UserData alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([UserData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        [_users addObject:obj];
    }
}

-(void)setFollowers:(NSMutableArray *)followers{
    _followers = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in followers) {
        UserData *obj = [[UserData alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([UserData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        [_followers addObject:obj];
    }
}

-(void)setFollowing:(NSMutableArray *)following{
    _following = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in following) {
        UserData *obj = [[UserData alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([UserData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        [_following addObject:obj];
    }
}

-(void)setRestaurants:(NSMutableArray *)restaurants{
    _restaurants = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in restaurants) {
        RestaurantData *obj = [[RestaurantData alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([RestaurantData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        [_restaurants addObject:obj];
    }
}

-(void)setDishes:(NSMutableArray *)dishes{
    _dishes = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dishes) {
        DishData *obj = [[DishData alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([DishData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        [_dishes addObject:obj];
    }
}

-(void)setComments:(NSArray *)comments{
    _comments = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in comments) {
        CommentData *obj = [[CommentData alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([CommentData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        [_comments addObject:obj];
    }
}

-(void)setCategories:(NSArray *)categories{
    _categories = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in categories) {
        if([dict respondsToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)]){
            CategoryItem *obj = [[CategoryItem alloc] init];
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                if ([CategoryItem instancesRespondToSelector:NSSelectorFromString(key)]) {
                    [obj setValue:value forKey:key];
                }
            }];
            [_categories addObject:obj];
        }else{
            [_categories addObjectsFromArray:categories];
            break;
        }
    }
}

-(void)setGooglePlaces:(NSArray *)googlePlaces{
    _googlePlaces = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dic in googlePlaces){
        GooglePlace *gp = [[GooglePlace  alloc] init];
        gp.placeId = [dic objectForKey:@"placeId"];
        gp.placeDescription = [dic objectForKey:@"description"];
        [_googlePlaces addObject:gp];
    }
}


-(void)setLatestActivity:(NSMutableArray *)latestActivity{
    _latestActivity = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in latestActivity) {
        NewsFeedData *obj = [[NewsFeedData alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            NSLog(@"key: %@ \n Value: %@", key, value);

            if ([NewsFeedData instancesRespondToSelector:NSSelectorFromString(key)]) {
                NSLog(@"key: %@ \n Value: %@", key, value);
                [obj setValue:value forKey:key];
            }
        }];
        [_latestActivity addObject:obj];
    }
}

@end
