//
//  UserModify.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/19/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UserModify.h"
#import "UserCategory.h"

@implementation UserModify

-(id)initWithUser:(User*)user{
    self = [super init];
    if(self){
        self.userName = user.userName;
        self.fullName = user.fullName;
        self.email = user.userName;
        self.email = user.email;
        self.userBio = user.userBio;
        if(user.userImage && user.userImage.length > 0)
            self.pictures = [NSArray arrayWithObjects:user.userImage, nil];
        
        if(user.categories.count > 0){
            NSMutableArray *categoryNames = [[NSMutableArray alloc] init];
            for(UserCategory *category in user.categories)
                [categoryNames addObject:category.name];
            self.categories = categoryNames;
        }
        
        if([user.locationLatitude doubleValue] != 0 && [user.locationLongitude doubleValue] != 0)
            self.location = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",[user.locationLongitude doubleValue]], [NSString stringWithFormat:@"%f",[user.locationLatitude doubleValue]], nil];
        
        self.locationName = user.locationName;
        self.range = user.locationRange;
        //self.useCustomLocation = user.useCustomLocation;
    }
    return self;
}

-(void)setFullName:(NSString *)fullName{
    if(fullName)
        _fullName = fullName;
}

-(void)setEmail:(NSString *)email{
    if(email)
        _email = email;
}


-(void)setPictures:(NSArray *)pictures{
    if(pictures)
        _pictures = pictures;
}

-(void)setUserName:(NSString *)userName{
    if(userName)
        _userName = userName;
}

-(void)setUserBio:(NSString *)userBio{
    if(userBio)
        _userBio = userBio;
}

-(void)setLatitude:(double)latitude andLongitude:(double)longitude{
    self.location = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",longitude], [NSString stringWithFormat:@"%f",latitude], nil];
}

@end
