//
//  DishData.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "DishData.h"

@implementation DishData

-(void)setUser:(NSDictionary *)user{
    id nullCheck = user;
    if (user && nullCheck != [NSNull null]) {
        _user = [[UserData alloc] init];
        [user enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([UserData instancesRespondToSelector:NSSelectorFromString(key)]) {
                [_user setValue:value forKey:key];
            }
        }];
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

-(void)setImage:(NSArray *)image{
    _image = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in image) {
        if([dict respondsToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)]){
            DishImageData *obj = [[DishImageData alloc] init];
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                if ([DishImageData instancesRespondToSelector:NSSelectorFromString(key)]) {
                    [obj setValue:value forKey:key];
                }
            }];
            [_image addObject:obj];
        }else{
            [_image addObjectsFromArray:image];
            break;
        }
    }
}

@end
