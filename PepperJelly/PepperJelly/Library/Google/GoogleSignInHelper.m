//
//  GoogleAPIHelper.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "GoogleSignInHelper.h"

@implementation GoogleSignInHelper

+(GoogleSignInHelper *)sharedInstance{
    static GoogleSignInHelper *googleSignInHelper;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        googleSignInHelper = [[GoogleSignInHelper alloc] init];
    });
    return googleSignInHelper;
}

-(void)initiate{
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].delegate = self;
}

#pragma mark - GoogleAPI
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if(user.authentication.idToken.length > 0){
        [self.delegate userSignedInWithUserId:user];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

-(void)getUserProfilePictureWithProfile:(GIDProfileData *)profile completionhandler:(void (^)(NSURL *url, BOOL success))completionHandler{
    
    if(profile.hasImage){
        NSURL *url = [profile imageURLWithDimension:116];
        if(url.absoluteString.length !=0){
            completionHandler(url, YES);
        }else{
            completionHandler(nil, NO);
        }
    }
}


@end
