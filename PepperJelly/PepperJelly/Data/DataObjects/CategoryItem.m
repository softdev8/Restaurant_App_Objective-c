//
//  CategoryItem.m
//  PepperJelly
//
//  Created by Sean McCue on 4/26/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "CategoryItem.h"
#import "Category.h"
#import "CDHelper.h"

@implementation CategoryItem

-(id)initWithName:(NSString *)name{
    self = [super init];
    if(self){
        self.name = name;
        self.subcategories = [[NSMutableArray alloc] init];
        self.subcategoriesToShow = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithCategory:(Category*)category selectedSubcategories:(NSArray *)selectedSubcategories{
    self = [super init];
    if(self){
        self.name = category.name;
        self.subcategories = [[NSMutableArray alloc] init];

        self.subcategoriesToShow = [[NSMutableArray alloc] init];
        NSArray *categories = [CDHelper sortArray:[category.children allObjects] by:@"name" ascending:YES];
        for(Category *category in categories){
            [self.subcategoriesToShow addObject:category.name];
            
            for(NSString *selectedCategory in selectedSubcategories)
                if([category.name isEqualToString:selectedCategory])
                    [self.subcategories addObject:category.name];
        }
    }
    return self;
}
@end
