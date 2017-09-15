//
//  FacebookLoginHelper.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/15/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FacebookLoginHelper : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *idToken;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *givenName;
@property (nonatomic, strong) NSString *familyName;
@property (nonatomic, strong) NSString *email;

+ (FacebookLoginHelper*)sharedInstance;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
-(void)signInFBWithController:(UIViewController *)controller completionHandler:(void (^)(NSString *token, NSError *error))completionHandler;


@end
