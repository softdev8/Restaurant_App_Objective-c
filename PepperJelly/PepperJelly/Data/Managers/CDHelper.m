//
//  CDHelper.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/2016.
//  Copyright (c) 2016. All rights reserved.
//

#import "CDHelper.h"
#import "DataAccess.h"

@implementation CDHelper

/**************LISTS*****************/

+(NSArray *)list:(NSString *)entityString{
    return [CDHelper list:entityString sort:@"" ascending:YES];
}

+(NSArray *)list:(NSString *)entityString sort:(NSString *)sortString ascending:(BOOL)ascending{
    NSManagedObjectContext *context = [DataAccess.sharedInstance managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityString inManagedObjectContext:context];
    NSError *error;
    [fetchRequest setEntity:entity];
    
    // Only sort by name if the destination entity actually has an "order" field
    if ([[[[fetchRequest entity] propertiesByName] allKeys] containsObject:sortString]) {
        NSSortDescriptor *sortByOrder = [[NSSortDescriptor alloc] initWithKey:sortString ascending:ascending];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByOrder]];
    }
    
    @try {
        if(context && fetchRequest)
        {
            NSArray *array = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&error]];
            return array;
        }
        else
        {
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error!");
        return nil;
    }
}

+(NSArray*)list:(NSString*)entityName withProperty:(NSString*)propertyName andValue:(id)value sort:(NSString*)sortString ascending:(BOOL)ascending{
    NSManagedObjectContext *context = [DataAccess.sharedInstance managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // retrive the objects with a given value for a certain property
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(%K == %@)", propertyName, value];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    if ([[[[fetchRequest entity] propertiesByName] allKeys] containsObject:sortString]) {
        NSSortDescriptor *sortByOrder = [[NSSortDescriptor alloc] initWithKey:sortString ascending:ascending];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByOrder]];
    }
    
    NSError *error = nil;
    @try {
        if(context && fetchRequest) {
            NSArray *result = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&error]];
            return result;
        } else {
            return nil;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error!");
        return nil;
    }
}

+(NSArray*)sortArray:(NSArray*)array by:(NSString*)sort ascending:(BOOL)ascending{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sort ascending:ascending]];
    return [array sortedArrayUsingDescriptors:sortDescriptors];
}

+(NSArray*)randomArray:(NSArray*)array{
    NSMutableArray *randomArray = [[NSMutableArray alloc] initWithArray:array];
    NSUInteger count = [randomArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [randomArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return randomArray;
}

/**************INSERT*****************/

+(NSNumber*)lastPKWithObject:(NSManagedObject*)object{
    NSManagedObjectID *moID = [object objectID];
    int pk = [[[[moID URIRepresentation] lastPathComponent] substringFromIndex:1] intValue];
    return [NSNumber numberWithInt:pk];
}

+(id)insert:(NSString *)entity{
    NSManagedObjectContext *context = [DataAccess.sharedInstance managedObjectContext];
    return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:context];
}

/**************DELETE*****************/

+(void)deleteObject:(NSManagedObject *)object{
    NSManagedObjectContext *context = [DataAccess.sharedInstance managedObjectContext];
    [context deleteObject:object];
}

/**************UPDATE*****************/
+ (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [DataAccess.sharedInstance managedObjectContext];
    
    if (managedObjectContext != nil)
    {
        @try {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        @catch (NSException *exception) {
            NSLog(@"error!");
        }
    }
}

+(void)save{
    NSManagedObjectContext *context = [DataAccess.sharedInstance managedObjectContext];
    NSError *error;
    @try {
        if(context)
        {
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Whoops, context error");
    }
}

+(void)saveAfterDelay{
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(save) userInfo:nil repeats:NO];
}


@end
