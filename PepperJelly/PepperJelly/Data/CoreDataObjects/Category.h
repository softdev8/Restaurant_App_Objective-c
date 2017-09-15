//
//  Category.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CategoryItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category : NSManagedObject

+(Category*)categoryWithId:(NSString*)categoryId;
+(Category *)categoryWithDictionary:(id)dictionary;
+(Category*)categoryWithCategoryData:(CategoryItem*)categoryData;
+(Category*)createWithId:(NSString*)categoryId;
+(Category *)createWithName:(NSString *)categoryName;
+(NSArray*)getAll;
+(NSArray *)getAllTopLevel;
+(void)clearCategories;

@end

NS_ASSUME_NONNULL_END

#import "Category+CoreDataProperties.h"
