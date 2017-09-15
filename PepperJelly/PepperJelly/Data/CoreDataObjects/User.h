//
//  User.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/18/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserData.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

+(User*)userWithId:(NSString*)userId;
+(User *)userWithUserData:(UserData*)userData;
+(User*)createWithId:(NSString*)userId;
+(NSArray *)getAll;
+(void)clearUsers;

-(void)clearFollowerUsers;
-(void)clearFollowingUsers;
-(void)clearReports;
-(void)clearDishes;
-(void)clearCategories;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
