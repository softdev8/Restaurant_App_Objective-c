//
//  AppDelegate.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "AppDelegate.h"
#import "DataAccess.h"
#import "GoogleSignInHelper.h"
#import "FacebookLoginHelper.h"
#import "NotificationManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Dish.h"
#import "APIManager.h"
#import "User.h"
#import <Mixpanel/Mixpanel.h>
#import <Cloudinary/Cloudinary-Swift.h>

@import HockeySDK;
@import Branch;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //set max cache for url requests
    [[NSURLCache sharedURLCache] setMemoryCapacity:1024*1024*CACHE_CAPACITY_IN_MB];
    
    //Temp diable auto layout logs
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    
    //Handle Remote Push
    NSDictionary *remoteNote = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNote){
        [self handleRemoteNotification:remoteNote];
    }
    
    // Mixpanel analytics
    [Mixpanel sharedInstanceWithToken:@"ccc1dbc378f5a4ae3416950be6c91470"];
    
    //HockeyApp
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"2ac815cd654445818b0f64c9ed568a59"];
    
    // Do some additional configuration if needed here
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator
     authenticateInstallation];
    
    //GoogleAPI
    [[GoogleSignInHelper sharedInstance] initiate];
    
    //FacebookAPI
    [[FacebookLoginHelper sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //Fabric
    [Fabric with:@[[Crashlytics class]]];
    [[Mixpanel sharedInstance] track:@"App Open"];
    [[Mixpanel sharedInstance].people increment:@"User App Open" by:@1];
    
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error && params) {
            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
            // params will be empty if no data found
            // ... insert custom logic here ...
            NSLog(@"params: %@", params.description);
        }
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Mixpanel sharedInstance] track:@"App Open"];
    // TODO MIXPANEL
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDidBecomeActive" object:nil];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[DataAccess sharedInstance] saveContext];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    [[Branch getInstance] handleDeepLink:url];
    if([[url absoluteString] containsString:@"facebook"])
        return [[FacebookLoginHelper sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    [[GoogleSignInHelper sharedInstance] application:app openURL:url options:options];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[Branch getInstance] handleDeepLink:url];
    if([[url absoluteString] containsString:@"facebook"])
        return [[FacebookLoginHelper sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    [[GoogleSignInHelper sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}

#pragma mark - Remote Notifications
-(void)handleRemoteNotification:(NSDictionary *)remoteNote{
    
    /*** USER FOLLOWED PAYLOAD ***/
    /*
     aps =     {
     alert = "some@email.com has started following you.";
     badge = <BADGE_COUNT>;
     };
     userId = <USER_ID>;
     */
    
    
    /*** USER DISH LIKED  ***/
    /*
     aps =     {
     alert = "some@email.com has liked one of you uploaded dishes.";
     badge = <BADGE_COUNT>;
     };
     dishId = <DISH_ID>;
     userId = <USER_ID>;
     */
    
    
    //1. TYPE - check if dishId is null
    if(remoteNote[@"dishId"] != nil){
        [NotificationManager sharedManager].dishId = remoteNote[@"dishId"];
    }
    else{
        if(remoteNote[@"userId"] != nil){
            [NotificationManager sharedManager].userId = remoteNote[@"userId"];
        }
    }

}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"didRegisterUser");
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"DEVICE TOKEN---%@", token);
    [NotificationManager sharedManager].deviceToken = token;
    User *user = [APIManager sharedInstance].user;
    if (user) {
        [[Mixpanel sharedInstance] identify:user.userId];
    }
    [[Mixpanel sharedInstance].people addPushDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error registering for remote notifications. Error: %@", [error localizedDescription]);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"user info: %@", userInfo);
    
    NSString *badgeCountStr;
    NSInteger badgeCount;
    
    if(userInfo[@"aps"] != nil){
        NSDictionary *aps = userInfo[@"aps"];
        if(aps[@"badge"] != nil){
            badgeCountStr = (NSString *)aps[@"badge"];
            NSLog(@"badge count: %@", badgeCountStr);
            badgeCount = [badgeCountStr integerValue];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
            [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_PUSH_ACTIVE_STATE object:nil];
        }
    }
    
    if(application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground){
        if(userInfo[@"dishId"] != nil){
            [NotificationManager sharedManager].dishId = userInfo[@"dishId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_PUSH_INACTIVE_STATE object:nil];
        }
        else{
            if(userInfo[@"userId"] != nil){
                [NotificationManager sharedManager].userId = userInfo[@"userId"];
                [[NSNotificationCenter defaultCenter] postNotificationName:REMOTE_PUSH_INACTIVE_STATE object:nil];
            }
        }
    }
    

}


@end
