//
//  User.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/18/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "User.h"
#import "CDHelper.h"
#import "Report.h"
#import "UserCategory.h"
#import "Constants.h"

@implementation User

+(User *)userWithId:(NSString *)userId{
    NSArray *users = [CDHelper list:@"User" withProperty:@"userId" andValue:userId sort:@"" ascending:YES];
    //NSArray *users2 = [CDHelper list:@"User" sort:@"" ascending:YES];
    
    for(User *user in users)
        if([user.userId isEqualToString:userId])
            return user;
    
    return nil;
}

+(User *)userWithUserData:(UserData *)userData{
    User *user = [self createWithId:userData._id];
    user.fullName = [userData getFullName];
    user.userName = userData.userName;
    user.userBio = [userData getUserBio];
    NSLog(@"----userBio%@",user.userBio);
    if(userData.password.length > 0)
        user.password = userData.password;
    user.userImage = [userData getPicture];
    user.email = [userData getEmail];
    user.followedCount = [userData getFollowed];
    user.followersCount = [userData getFollowers];
    user.dishCount = [userData getDishes];
    user.restaurants = [userData getRestaurants];
    user.likeCount = [userData getLikes];
    user.useCustomLocation = userData.useCustomLocation;
    
    if(![userData.range isKindOfClass:[NSNull class]] && userData.range != nil)
        user.locationRange = userData.range;
    
    user.locationName = userData.locationName;
    
    if(userData.location && [userData.location respondsToSelector:@selector(count)] && userData.location.count == 2){
        user.locationLongitude = [userData.location objectAtIndex:0];
        user.locationLatitude = [userData.location objectAtIndex:1];
    }
    
    [user clearReports];
    for(NSDictionary *reportDic in userData.reports){
        Report *report = [CDHelper insert:@"Report"];
        report.reason = reportDic[@"reason"];
        report.date = reportDic[@"createdAt"];
        report.user = user;
        [user addReportsObject:report];
    }
    
    if(userData.categories){
        [user clearCategories];
        for(NSString *categoryDic in userData.categories){
            UserCategory *category = [CDHelper insert:@"UserCategory"];
            category.name = categoryDic;
            category.user = user;
            [user addCategoriesObject:category];
        }
    }
    
    return user;
}

+(User *)createWithId:(NSString *)userId{
    User *user = [self userWithId:userId];
    
    if(user)
        return user;
    
    user = [CDHelper insert:@"User"];
    user.userId = userId;
    return user;
}

+(NSArray *)getAll{
    return [CDHelper list:@"User" sort:@"userName" ascending:YES];
}

+(void)clearUsers{
    NSArray *users = [CDHelper list:@"User" sort:@"name" ascending:NO];
    for(User *user in users)
        [CDHelper deleteObject:user];
}

-(void)clearFollowerUsers{
    [[self mutableSetValueForKey:@"followerUsers"] removeAllObjects];
}

-(void)clearFollowingUsers{
    [[self mutableSetValueForKey:@"followingUsers"] removeAllObjects];
}

-(void)clearReports{
    [[self mutableSetValueForKey:@"reports"] removeAllObjects];
}

-(void)clearDishes{
    [[self mutableSetValueForKey:@"dishes"] removeAllObjects];
}

-(void)clearCategories{
    [[self mutableSetValueForKey:@"categories"] removeAllObjects];
}


@end
