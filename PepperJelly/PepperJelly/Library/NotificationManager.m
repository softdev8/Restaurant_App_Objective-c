//
//  NotificationManager.m
//  GalPal
//
//  Created by Sean McCue on 3/23/16.
//  Copyright © 2016 DogTown Media. All rights reserved.
//

#import "NotificationManager.h"
#import "Constants.h"

@implementation NotificationManager

+(instancetype)sharedManager{
    static NotificationManager *notificationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notificationManager = [[self alloc] init];
    });
    return notificationManager;
}

-(void)configureRemoteNotifications{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        NSLog(@"ios 8 or above");
        UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge) | (UIUserNotificationTypeSound) | (UIUserNotificationTypeAlert);
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }else{
        NSLog(@"ios 7");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge) | (UIUserNotificationTypeSound) | (UIUserNotificationTypeAlert)];
    }
}

-(void)setDishId:(NSString *)dishId{
    _dishId = dishId;
    if(dishId.length > 0){
        self.userEnteredAppFrtomRemoreNotification = true;
    }else{
        self.userEnteredAppFrtomRemoreNotification = false;
    }
}

-(void)setUserId:(NSString *)userId{
    _userId = userId;
    if(userId.length > 0){
        self.userEnteredAppFrtomRemoreNotification = true;
    }else{
        self.userEnteredAppFrtomRemoreNotification = false;
    }
}


@end
