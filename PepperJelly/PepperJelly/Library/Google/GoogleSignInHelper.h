//
//  GoogleAPIHelper.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/SignIn.h>

@protocol GoogleSignHelperDelegate <NSObject>
@required
-(void)userSignedInWithUserId:(GIDGoogleUser *)user;
@end

@interface GoogleSignInHelper : NSObject <GIDSignInDelegate>

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *idToken;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *givenName;
@property (nonatomic, strong) NSString *familyName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, weak) id<GoogleSignHelperDelegate>delegate;
+ (GoogleSignInHelper*)sharedInstance;

- (void)initiate;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
-(void)getUserProfilePictureWithProfile:(GIDProfileData *)profile completionhandler:(void (^)(NSURL *url, BOOL success))completionHandler;


@end
