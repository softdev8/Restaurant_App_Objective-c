//
//  Category.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "Category.h"
#import "CDHelper.h"

@implementation Category

+(Category *)categoryWithId:(NSString *)categoryId{
    NSArray *categories = [CDHelper list:@"Category" sort:@"" ascending:YES];
    
    for(Category *category in categories)
        if([category.categoryId isEqualToString:categoryId])
            return category;
    
    return nil;
}

+(Category *)categoryWithName:(NSString *)name{
    NSArray *categories = [CDHelper list:@"Category" sort:@"" ascending:YES];
    
    for(Category *category in categories)
        if([category.name isEqualToString:name])
            return category;
    
    return nil;
}

+(Category *)categoryWithCategoryData:(CategoryItem *)categoryData{
    Category *category = [self createWithId:categoryData._id];
    category.name = categoryData.name;
    category.categoryId = categoryData._id;
    return category;
}

+(Category *)categoryWithDictionary:(id)dictionary{
    Category *category = [self createWithName:dictionary];
    category.name = dictionary;
    return category;
}

+(Category *)createWithId:(NSString *)categoryId{
    Category *category = [self categoryWithId:categoryId];
    
    if(category)
        return category;
    
    category = [CDHelper insert:@"Category"];
    category.categoryId = categoryId;
    return category;
}

+(Category *)createWithName:(NSString *)categoryName{
    Category *category = [self categoryWithName:categoryName];
    
    if(category)
        return category;
    
    category = [CDHelper insert:@"Category"];
    category.name = categoryName;
    return category;
}

+(NSArray *)getAll{
    NSArray *categories = [CDHelper list:@"Category" sort:@"name" ascending:YES];
    NSMutableArray *lowerLevel = [[NSMutableArray alloc] init];
    
    for(Category *category in categories){
        if(category.children.count == 0)
            [lowerLevel addObject:category];
    }
    
    return lowerLevel;
}

+(NSArray *)getAllTopLevel{
    NSArray *categories = [CDHelper list:@"Category" sort:@"order" ascending:YES];
    NSMutableArray *topLevel = [[NSMutableArray alloc] init];
    
    for(Category *category in categories){
        if(category.children.count > 0)
           [topLevel addObject:category];
    }
    
    return topLevel;
}

+(void)clearCategories{
    NSArray *categories = [CDHelper list:@"Category"];
    for(Category *category in categories)
        [CDHelper deleteObject:category];
    [CDHelper save];
}

@end
