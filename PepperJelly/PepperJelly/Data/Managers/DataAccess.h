//
//  DataAccess.h
//  PepperJelly
//
//  Created by Evandro H Hoffmann on 3/9/2016.
//  Copyright (c) 2016 Evandro H Hoffmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataAccess : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DataAccess*)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
