//
//  FacebookLoginHelper.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/15/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "FacebookLoginHelper.h"

@implementation FacebookLoginHelper

+(FacebookLoginHelper *)sharedInstance{
    static FacebookLoginHelper *facebookLoginHelper;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        facebookLoginHelper = [[FacebookLoginHelper alloc] init];
    });
    return facebookLoginHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
}

-(void)signInFBWithController:(UIViewController *)controller completionHandler:(void (^)(NSString *token, NSError *error))completionHandler{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     fromViewController:controller
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             completionHandler(nil, error);   // Return Error
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             completionHandler(nil, error);   // Return Error
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             if(result){
                 if([result.grantedPermissions containsObject:@"email"]){
                     if([[FBSDKAccessToken currentAccessToken]tokenString]){
                         NSString *token = [[FBSDKAccessToken currentAccessToken]tokenString];
                         completionHandler(token, nil);   // Return FB Access token
                     }
                 }
                 
             }
         }
     }];
}

@end
