//
//  Category+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *categoryId;
@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) Category *parent;
@property (nullable, nonatomic, retain) NSSet<Category *> *children;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Category *)value;
- (void)removeChildrenObject:(Category *)value;
- (void)addChildren:(NSSet<Category *> *)values;
- (void)removeChildren:(NSSet<Category *> *)values;

@end

NS_ASSUME_NONNULL_END
