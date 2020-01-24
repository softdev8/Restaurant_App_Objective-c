//
//  CDHelper.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/2016.
//  Copyright (c) 2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define STATUS_ACTIVE 0
#define STATUS_DELETED 1
#define STATUS_ALL 2

@interface CDHelper : NSObject

+(NSArray *)list:(NSString *)entityString;
+(NSArray*)list:(NSString*)entity sort:(NSString*)sort ascending:(BOOL)ascending;
+(NSArray*)list:(NSString*)entityName withProperty:(NSString*)propertyName andValue:(id)value sort:(NSString*)sort ascending:(BOOL)ascending;
+(NSArray*)sortArray:(NSArray*)array by:(NSString*)sort ascending:(BOOL)ascending;
+(NSArray*)randomArray:(NSArray*)array;

+(NSNumber*)lastPKWithObject:(NSManagedObject*)object;
+(id)insert:(NSString*)entity;

+(void)deleteObject:(NSManagedObject*)object;
+ (void)saveContext;

+(void)save;
+(void)saveAfterDelay;

@end
