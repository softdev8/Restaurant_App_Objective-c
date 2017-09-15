//
//  NewsFeedData.m
//  PepperJelly
//
//  Created by Sean McCue on 7/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "NewsFeedData.h"
#import "DishImageData.h"

@implementation NewsFeedData
-(void)setDishPhoto:(NSArray *)dishPhoto{
    _dishPhoto = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in dishPhoto){
        if([dict respondsToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)]){
            DishImageData *obj = [[DishImageData alloc] init];
            [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                if([DishImageData instanceMethodForSelector:NSSelectorFromString((key))]){
                    [obj setValue:value forKey:key];
                }
            }];
            [_dishPhoto addObject:obj];
        }else{
            [_dishPhoto arrayByAddingObjectsFromArray:dishPhoto];
            break;
        }
    }
}
@end
