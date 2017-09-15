//
//  Report+CoreDataProperties.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Report.h"

NS_ASSUME_NONNULL_BEGIN

@interface Report (CoreDataProperties)


@property (nullable, nonatomic, retain) NSString *reason;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
