//
//  NotificationManager.h
//  GalPal
//
//  Created by Sean McCue on 3/23/16.
//  Copyright © 2016 DogTown Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NotificationManager : NSObject
+(instancetype)sharedManager;
@property (nonatomic, strong) NSString *dishId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *deviceToken;
-(void)configureRemoteNotifications;
@property (nonatomic, assign) BOOL userEnteredAppFrtomRemoreNotification;
@end
