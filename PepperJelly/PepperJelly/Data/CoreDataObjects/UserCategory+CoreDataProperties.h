//
//  UserCategory+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/28/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCategory (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
