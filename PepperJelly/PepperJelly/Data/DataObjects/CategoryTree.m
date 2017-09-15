//
//  CategoriesResponse.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 08/07/2016.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "CategoryTree.h"
#import "CategoryItem.h"

@implementation CategoryTree

-(void)setCategories:(NSDictionary *)categories{
    _categories = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in categories) {
        CategoryItem *obj = [[CategoryItem alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([CategoryItem instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        [_categories addObject:obj];
    }
}
@end
