//
//  UserTest.m
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UserData.h"

@implementation UserData

#pragma mark - fullname

-(void)setFullName:(NSString *)name{
    if(!_profile)
        _profile = [[NSMutableDictionary alloc] init];
    [_profile setValue:name forKey:@"fullName"];
}

-(NSString *)getFullName{
    return _profile[@"fullName"];
}

#pragma mark - userBio

-(void)setUserBio:(NSString *)userBio{
    if(!_profile)
        _profile = [[NSMutableDictionary alloc] init];
    [_profile setValue:userBio forKey:@"userBio"];
}

-(NSString *)getUserBio{
    return _profile[@"userBio"];
}
#pragma mark - email

-(void)setEmail:(NSString *)email{
    if(!_profile)
        _profile = [[NSMutableDictionary alloc] init];
    [_profile setValue:email forKey:@"email"];
}

-(NSString *)getEmail{
    return _profile[@"email"];
}

#pragma mark - followers

-(void)setFollowers:(NSNumber*)followers{
    if(!_stats)
        _stats = [[NSMutableDictionary alloc] init];
    [_stats setValue:followers forKey:@"followers"];
}

-(NSNumber*)getFollowers{
    return _stats[@"followers"];
}

#pragma mark - followed

-(void)setFollowed:(NSNumber*)followed{
    if(!_stats)
        _stats = [[NSMutableDictionary alloc] init];
    [_stats setValue:followed forKey:@"followed"];
}

-(NSNumber*)getFollowed{
    return _stats[@"followed"];
}

#pragma mark - dishes

-(void)setDishes:(NSNumber*)dishes{
    if(!_stats)
        _stats = [[NSMutableDictionary alloc] init];
    [_stats setValue:dishes forKey:@"dishes"];
}

-(NSNumber*)getDishes{
    return _stats[@"dishes"];
}

#pragma mark - likes

-(void)setLikes:(NSNumber*)likes{
    if(!_stats)
        _stats = [[NSMutableDictionary alloc] init];
    [_stats setValue:likes forKey:@"likes"];
}

-(NSNumber*)getLikes{
    return _stats[@"likes"];
}

#pragma mark - likes

-(void)setRestaurants:(NSNumber*)restaurants{
    if(!_stats)
        _stats = [[NSMutableDictionary alloc] init];
    [_stats setValue:restaurants forKey:@"restaurants"];
}

-(NSNumber*)getRestaurants{
    return _stats[@"restaurants"];
}

#pragma mark - pictures

-(void)setPictures:(NSArray *)pictures{
    if(!_profile)
        _profile = [[NSMutableDictionary alloc] init];
    [_profile setValue:pictures forKey:@"pictures"];
}

-(NSArray *)getPictures{
    return _profile[@"pictures"];
}

-(NSString*)getPicture{
    NSArray *pictures = [self getPictures];
    
    if(pictures && pictures.count > 0)
        return [pictures objectAtIndex:0];
    return @"";
}

#pragma userNew

@end
