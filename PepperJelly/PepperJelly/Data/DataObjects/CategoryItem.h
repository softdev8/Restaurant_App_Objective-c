//
//  CategoryItem.h
//  PepperJelly
//
//  Created by Sean McCue on 4/26/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Category;

@interface CategoryItem : NSObject
@property (nonatomic, strong)NSString *_id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSArray *categories;

@property (nonatomic, strong) NSMutableArray *subcategoriesToShow;
@property (nonatomic, strong) NSMutableArray *subcategories;

-(id)initWithName:(NSString*)name;
-(id)initWithCategory:(Category*)category selectedSubcategories:(NSArray*)selectedSubcategories;
@end
