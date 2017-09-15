//
//  APIManagerExample.m
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "APIManager.h"
#import "APIRequestManager.h"
#import <AWSCore/AWSCore.h>
#import <AWSS3/AWSS3.h>
#import "APIResponse.h"
#import "UserData.h"
#import "UserModify.h"
#import "Search.h"
#import "RestaurantData.h"
#import "DishData.h"
#import "CommentData.h"
#import "ReportUser.h"
#import "CategoryItem.h"
#import "Category.h"
#import "GooglePlace.h"
#import "BlockUser.h"
#import "FeedSearch.h"
#import "UIImage+Cropping.h"
#import "CategoryTree.h"
#import "NewsFeed.h"
#import <Mixpanel/Mixpanel.h>
#import <SDWebImage/SDWebImagePrefetcher.h>


@implementation APIManager

+ (APIManager *)sharedInstance {
    static APIManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIManager alloc] init];
        [_sharedInstance loadDefaults];
    });
    return _sharedInstance;
}

#pragma UserDefaults

-(void)saveDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:self.user.userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:self.authToken forKey:@"authToken"];
    [[NSUserDefaults standardUserDefaults] setBool:self.offlineMode forKey:@"offlineMode"];
    [[NSUserDefaults standardUserDefaults] setBool:self.didShowTutorialForRestaurant forKey:@"didShowTutorialForRestaurant"];
    
    //save database changes
    [CDHelper save];
}

-(void)loadDefaults{
    self.user = [User userWithId:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    self.authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"];
    self.offlineMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"offlineMode"];
    self.didShowTutorialForRestaurant = [[NSUserDefaults standardUserDefaults] boolForKey:@"didShowTutorialForRestaurant"];
}

-(void)logoutUser{
    [CDHelper deleteObject:self.user];
    [FeedSearch clearSearches];
    [User clearUsers];
    [CDHelper save];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authToken"];
    
    self.user = nil;
    self.authToken = nil;
}

-(BOOL)isLoggedIn{
    return self.authToken != nil && self.authToken.length > 0 && self.user != nil;
}

#pragma mark - Validations

+(BOOL)isValidEmail:(NSString*)email{
    if([email length] == 0)
        return false;
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidPassword:(NSString *)password{
    return password.length >= 6;
}

+(BOOL)isValidName:(NSString *)name{
    return name.length > 0;
}

+(BOOL)isValidUserName:(NSString *)username{
    return username.length > 0;
}

#pragma mark - Alerts

+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController*)viewController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"error_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated:true completion:^{
        
    }];
}

#pragma Account Services

-(void)userRegisterWithFacebookToken:(NSString *)token completionHandler:(void (^)(BOOL success, APIResponse *obj))completion{
    UserData *user = [[UserData alloc] init];
    [user setAccess_token:token];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserFBLoginUrl andAuthorization:nil responseClass:[APIResponse class] ignoringParams:@[@"role"] completion:^(BOOL success, id obj) {
        
        APIResponse *response = (APIResponse *)obj;
        if (success) {
            self.user = [User userWithUserData:response.user];
            self.authToken = response.authToken;
            [self saveDefaults];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)userRegisterWithGoogleId:(NSString *)_id email:(NSString *)email name:(NSString *)name userPicture:(NSString *)userPic completionHandler:(void (^)(BOOL success, APIResponse *obj))completion{
    UserData *user = [[UserData alloc] init];
    
    [user setGoogleId:_id];
    [user setUserName:email];
    [user setFullName:name];
    [user setPictures:@[userPic]];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserRegisterURL andAuthorization:nil responseClass:[APIResponse class] ignoringParams:@[@"role"] completion:^(BOOL success, APIResponse *response) {
        
        self.user = [User userWithUserData:response.user];
        self.authToken = response.authToken;
        [self saveDefaults];
        
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)signUpWithName:(NSString *)name email:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *user = [[UserData alloc] init];
    [user setUserName:email];
    [user setPassword:password];
    [user setFullName:name];

    [[APIRequestManager sharedInstance] POST:user withURL:kUserRegisterURL andAuthorization:nil responseClass:[APIResponse class] ignoringParams:@[@"role"] completion:^(BOOL success, APIResponse *response) {
        self.user = [User userWithUserData:response.user];
        self.user.password = password;
        self.authToken = response.authToken;
        [self saveDefaults];
        
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *user = [[UserData alloc] init];
    [user setUserName:email];
    [user setPassword:password];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserLoginURL andAuthorization:nil responseClass:[APIResponse class] ignoringParams:@[@"role"] completion:^(BOOL success, APIResponse *response) {
        if (success) {
            response.user.password = password;
            self.user = [User userWithUserData:response.user];
            self.authToken = response.authToken;
            [self saveDefaults];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)forgotPasswordWithEmail:(NSString *)email completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *user = [[UserData alloc] init];
    [user setUserName:email];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserForgotPasswordURL andAuthorization:self.authToken responseClass:[APIResponse class] ignoringParams:@[@"role"] completion:^(BOOL success, APIResponse *response) {
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)changePassword:(NSString *)password completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *user = [[UserData alloc] init];
    [user setPassword:password];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserPasswordURL andAuthorization:self.authToken responseClass:[APIResponse class] ignoringParams:@[@"role"] completion:^(BOOL success, APIResponse *response) {
        if (success) {
            response.user.password = password;
            self.user = [User userWithUserData:response.user];
            [self saveDefaults];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)modifyUser:(UserModify*)user completion:(void (^)(BOOL success, APIResponse *response))completion{
    [[APIRequestManager sharedInstance] POST:user withURL:kUserModifyURL andAuthorization:self.authToken responseClass:[APIResponse class] ignoringParams:@[@"role"] completion:^(BOOL success, APIResponse *response) {
        if (success) {
            self.user = [User userWithUserData:response.user];
            [self saveDefaults];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)userReportUserWithID:(NSString *)userid reason:(NSString *)reason completionHandler:(void (^)(BOOL success, APIResponse *obj))completion{
    NSLog(@"userID: %@", userid);
    ReportUser *report = [[ReportUser alloc] init];
    report.motive = reason;
    report.reportedUser = userid;
    
    [[APIRequestManager sharedInstance] POST:report withURL:kUserReportURL andAuthorization:self.authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, id obj) {
        
        APIResponse *response = (APIResponse *)obj;
        
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}


-(void)userBlockUserWithID:(NSString *)userid completionHandler:(void (^)(BOOL success, APIResponse *obj))completion{
    NSLog(@"userID: %@", userid);
    BlockUser *user = [[BlockUser alloc] init];
    user.blockedUser = userid;

    [[APIRequestManager sharedInstance] POST:user withURL:kUserBlock andAuthorization:self.authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, id obj) {
        
        APIResponse *response = (APIResponse *)obj;
        
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
        
    }];
}

#pragma mark - AWS Services

-(void)userUploadPhoto:(UIImage *)photo completionHandler:(void (^)(BOOL success, NSString *url))completion{
    AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:kAWSAccessKey secretKey:kAWSSecretKey];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:kAWSServer credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.8f);
    
    AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
    getPreSignedURLRequest.bucket = kAWSBucket;
    getPreSignedURLRequest.key = [NSString stringWithFormat:@"users/%@/%@", self.user.userId,fileName];
    getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodPUT;
    getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
    
    NSString *fileContentTypeString = @"text/plain";
    getPreSignedURLRequest.contentType = fileContentTypeString;
    
    [[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest] continueWithBlock:^id(AWSTask *task) {
        
        if (task.error) {
            completion(NO,nil);
        } else {
            
            NSURL *presignedURL = task.result;
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:presignedURL];
            request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            [request setHTTPMethod:@"PUT"];
            [request setValue:fileContentTypeString forHTTPHeaderField:@"Content-Type"];
            
            NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"There was an error... %@", error);
                    completion(NO,nil);
                } else {
                    NSString *returnUrl = [NSString stringWithFormat:@"%@/%@/%@", kAWSURL, self.user.userId,fileName];
                    completion(YES,returnUrl);
                }
            }];
            
            [uploadTask resume];
        }
        
        return nil;
    }];
}

-(void)userUploadPhoto:(UIImage *)photo withSizes:(NSArray*)sizes urls:(NSArray*)urls completionHandler:(void(^)(BOOL success, NSMutableArray *imageURLS))completionHandler{
    NSMutableArray *sizesMutableArray = [[NSMutableArray alloc] initWithArray:sizes];
    NSMutableArray *urlMutableArray = [[NSMutableArray alloc] initWithArray:urls];
    
    if(sizesMutableArray.count > 0){
        NSValue *value = [sizesMutableArray firstObject];
        CGSize size = [value CGSizeValue];
        [sizesMutableArray removeObjectAtIndex:0];
        
        [[APIManager sharedInstance] userUploadPhoto:[UIImage squareImageWithImage:photo scaledToSize:size] completionHandler:^(BOOL success, NSString *url) {
            if(success){
                [urlMutableArray addObject:[[DishImageData alloc] initWithUrl:url size:size]];
                NSLog(@"uploaded url: %@", url);
            }else{
                NSLog(@"error uploading photo");
            }
            
            //go to next picture
            [self userUploadPhoto:photo withSizes:sizesMutableArray urls:urlMutableArray completionHandler:completionHandler];
        }];
    }else{
        //no more pictures to load, finish request
        completionHandler(urlMutableArray.count > 0, urlMutableArray);
    }
}

#pragma mark - Search Services

-(void)searchUsersWithSearch:(Search *)search completion:(void (^)(BOOL success, APIResponse *response))completion{    
    [[APIRequestManager sharedInstance] POST:search withURL:kUserSearchURL andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            NSMutableArray *users = [[NSMutableArray alloc] init];
            if ([response.users respondsToSelector:@selector(count)]) {
                for (UserData *userData in response.users)
                    [users addObject:[User userWithUserData:userData]];
                [CDHelper save];
            }
            response.results = users;
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)getUserWithUserName:(NSString *)userName completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *user = [[UserData alloc] init];
    [user setUserName:userName];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserGetURL andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            [User userWithUserData:response.user];
            [CDHelper save];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)getUserWithUserId:(NSString *)userId completion:(void (^)(BOOL success, User *user))completion{
    UserData *user = [[UserData alloc] init];
    [user set_id:userId];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserGetURL andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            
        NSLog(@"User Data: %@", response.user.userName);
        NSLog(@"User Bio: %@", response.user.userBio);
        NSLog(@"User ID: %@", response.user.userId);
        NSLog(@"User Data: %@", response.user.getPictures);

           User *user = [User userWithUserData:response.user];
            
            completion(YES, user);
        } else {
            completion(NO, nil);
        }
    }];
}

-(void)searchRestaurantWithInput:(NSString *)input latitude:(float)latitude longitude:(float)longitude  radius:(float)radius completionHandler:(void (^)(BOOL success, APIResponse *response))completion{
    NSString *url = [NSString stringWithFormat:@"%@?input=%@&location=%f,%f&radius=%f", kSearchPlace, [input stringByReplacingOccurrencesOfString:@" " withString:@"+"], latitude, longitude, radius];
    NSLog(@"URL: %@", url);
    [[APIRequestManager sharedInstance] GETwithURL:url andAuthorization:_authToken responseClass:[APIResponse class] completion:^(BOOL success, APIResponse*response) {
        if(success){
            NSLog(@"success: %@", response.results);
            
            if([response.results respondsToSelector:@selector(count)]){
                response.googlePlaces = [response.results copy];
            }
            completion(YES, response);
        }else{
            NSLog(@"failure");
            completion(NO, nil);
        }
    }];
}

#pragma mark - Follow Services

-(void)followUserWithId:(NSString *)userId completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *user = [[UserData alloc] init];
    [user setFollowedUser:userId];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserFollowURL andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            User *followUser = [User userWithId:userId];
            if(followUser){
                [self.user addFollowingUsersObject:followUser];
                [followUser addFollowerUsersObject:self.user];
            }
            [CDHelper save];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)unfollowUserWithId:(NSString *)userId completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *user = [[UserData alloc] init];
    [user setFollowedUser:userId];
    
    [[APIRequestManager sharedInstance] POST:user withURL:kUserUnfollowURL andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            User *unfollowUser = [User userWithId:userId];
            if(unfollowUser)
                [self.user removeFollowingUsersObject:unfollowUser];
            [CDHelper save];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)getFollowersWithUser:(User*)user completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *userData = [[UserData alloc] init];
    userData.userId = user.userId;
    
    [[APIRequestManager sharedInstance] POST:userData withURL:kUserGetFollowersURL andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            if ([response.followers respondsToSelector:@selector(count)]) {
                [user clearFollowerUsers];
                for (UserData *userData in response.followers) {
                    User *follower = [User userWithUserData:userData];
                    [user addFollowerUsersObject:follower];
                    [follower addFollowingUsersObject:user];
                }
                [CDHelper save];
            }
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)getFollowingWithUser:(User*)user completion:(void (^)(BOOL success, APIResponse *response))completion{
    UserData *userData = [[UserData alloc] init];
    userData.userId = user.userId;
    
    [[APIRequestManager sharedInstance] POST:userData withURL:kUserGetFollowingURL andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            if ([response.following respondsToSelector:@selector(count)]) {
                [user clearFollowingUsers];
                for (UserData *userData in response.following) {
                    User *followingUser = [User userWithUserData:userData];
                    [user addFollowingUsersObject:followingUser];
                    [followingUser addFollowerUsersObject:user];
                }
                [CDHelper save];
            }
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

#pragma mark - Restaurant Services

-(void)getRestaurantsWithCompletion:(void (^)(BOOL success, APIResponse *response))completion{
    RestaurantData *restaurantData = [[RestaurantData alloc] init];
    
    [[APIRequestManager sharedInstance] POST:restaurantData withURL:kRestaurantGetUrl andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            NSMutableArray *restaurants = [[NSMutableArray alloc] init];
            if ([response.restaurants respondsToSelector:@selector(count)]) {
                for (RestaurantData *restaurantData in response.restaurants){
                    [restaurants addObject:[Restaurant restaurantWithRestaurantData:restaurantData]];
                }
                [CDHelper save];
            }
            response.results = restaurants;
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)getRestaurantWithId:(NSString*)restaurantId completion:(void (^)(BOOL success, APIResponse *response))completion{
    RestaurantData *restaurantData = [[RestaurantData alloc] init];
    restaurantData._id = restaurantId;
    
    [[APIRequestManager sharedInstance] POST:restaurantData withURL:kRestaurantGetUrl andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        
        if (success) {
            NSMutableArray *restaurants = [[NSMutableArray alloc] init];
            if ([response.restaurants respondsToSelector:@selector(count)]) {
                for (RestaurantData *restaurantData in response.restaurants)
                    [restaurants addObject:[Restaurant restaurantWithRestaurantData:restaurantData]];
                [CDHelper save];
            }
            response.results = restaurants;
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)searchRestaurantsWithSearch:(Search *)search completion:(void (^)(BOOL success, APIResponse *response)) completion
{
    [[APIRequestManager sharedInstance] POST:search withURL:kRestaurantGetUrl andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            NSMutableArray *restaurants = [[NSMutableArray alloc] init];
            if ([response.restaurants respondsToSelector:@selector(count)]) {
                for (RestaurantData *restaurantData in response.restaurants)
                    [restaurants addObject:[Restaurant restaurantWithRestaurantData:restaurantData]];
                [CDHelper save];
            }
            response.results = restaurants;
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
    
    

}

#pragma mark - Dish Services

-(void)createDishWithImage:(NSArray*)image restaurantId:(NSString *)restaurantId caption:(NSString *)caption categories:(NSArray *)categories rating:(NSNumber *)rating completion:(void (^)(BOOL, APIResponse *))completion{
    DishData *dishData = [[DishData alloc] init];
    dishData.image = [[NSMutableArray alloc] initWithArray:image];
    dishData.restaurantId = restaurantId;
    dishData.comment = caption;
    dishData.rating = rating;
    
    [[APIRequestManager sharedInstance] POST:dishData withURL:kDishCreateUrl andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)createDishWithImage:(NSArray*)image googleplaceId:(NSString *)googleplaceId caption:(NSString *)caption categories:(NSArray *)categories rating:(NSNumber *)rating completion:(void (^)(BOOL, APIResponse *))completion{
    DishData *dishData = [[DishData alloc] init];
    dishData.image = [[NSMutableArray alloc] initWithArray:image];
    dishData.placeId = googleplaceId;
    dishData.comment = caption;
    dishData.categories = categories;
    dishData.rating = rating;
    
    [[APIRequestManager sharedInstance] POST:dishData withURL:kDishCreateUrl andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)likeDishWithId:(NSString*)dishId like:(BOOL)like completion:(void (^)(BOOL success, APIResponse *response))completion{
    [[Mixpanel sharedInstance] track:@"Liked Dish"];
    DishData *dishData = [[DishData alloc] init];
    dishData.like = [NSNumber numberWithBool:like];
    
    [[APIRequestManager sharedInstance] POST:dishData withURL:[NSString stringWithFormat:kDishLikeUrl, dishId] andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            Dish *dish = [Dish dishWithId:dishId];
            dish.currentUserLike = [NSNumber numberWithBool:like];
            [CDHelper save];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)commentDishWithId:(NSString*)dishId comment:(NSString*)comment completion:(void (^)(BOOL success, APIResponse *response))completion{
    DishData *dishData = [[DishData alloc] init];
    dishData.comment = comment;
    
    [[APIRequestManager sharedInstance] POST:dishData withURL:[NSString stringWithFormat:kDishCommentUrl, dishId] andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)getDishWithId:(NSString*)dishId completion:(void (^)(BOOL success, Dish *response))completion{
    DishData *dishData = [[DishData alloc] init];
    
    [[APIRequestManager sharedInstance] POST:dishData withURL:[NSString stringWithFormat:kDishGetUrl, dishId] andAuthorization:_authToken responseClass:[dishData class] ignoringParams:nil completion:^(BOOL success, DishData *response) {
        if (success) {
          Dish *dish = [Dish dishWithDishData:response];
            completion(YES, dish);
        } else {
            completion(NO, nil);
        }
    }];
}

-(void)searchDishesWithSearch:(Search*)search completion:(void (^)(BOOL success, APIResponse *response))completion{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [[APIRequestManager sharedInstance] POST:search withURL:kDishSearchUrl andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
            //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                if (success) {
                    NSMutableArray *dishes = [[NSMutableArray alloc] init];
                    if ([response.dishes respondsToSelector:@selector(count)]) {
                        for (DishData *dishData in response.dishes)
                            [dishes addObject:[Dish dishWithDishData:dishData]];
                        [CDHelper save];
                    }
                    response.results = [CDHelper sortArray:dishes by:@"createdAt" ascending:NO];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(YES, response);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NO, response);
                    });
                }
            //});
        }];
    });
}

-(void)getDishesFeedWithSearch:(Search*)search completion:(void (^)(BOOL success, APIResponse *response))completion{
    [[APIRequestManager sharedInstance] POST:search withURL:kDishFeed andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            
            NSMutableArray *dishes = [[NSMutableArray alloc] init];
            NSMutableArray *urls = [[NSMutableArray alloc] init];
            
            if ([response.dishes respondsToSelector:@selector(count)]) {
                for (DishData *dishData in response.dishes) {
                    Dish *tmpDish = [Dish dishWithDishData:dishData];
                    [dishes addObject:tmpDish];
                    [urls addObject:[NSURL URLWithString:tmpDish.thumbImageUrl] ];
                }
                [CDHelper save];
            }
            response.results = [CDHelper randomArray:dishes];
            
            NSTimeInterval timeInSecondsStart = [[NSDate date] timeIntervalSince1970];
            //[[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
                
            //} completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
            //    NSTimeInterval timeInSecondsEnd = [[NSDate date] timeIntervalSince1970];
            //    NSLog(@"download time = %f", timeInSecondsEnd - timeInSecondsStart);
            //}];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)getLikedDishesWithCompletion:(void (^)(BOOL success, APIResponse *response))completion{
    [[APIRequestManager sharedInstance] POST:nil withURL:kDishLikedUrl andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            NSMutableArray *dishes = [[NSMutableArray alloc] init];
            if ([response.dishes respondsToSelector:@selector(count)]) {
                for (DishData *dishData in response.dishes)
                    [dishes addObject:[Dish dishWithDishData:dishData]];
                [CDHelper save];
            }
            response.results = [CDHelper sortArray:dishes by:@"createdAt" ascending:NO];
            
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)flagDishWithId:(NSString*)dishId motive:(NSString*)motive completion:(void (^)(BOOL success, APIResponse *response))completion{
    DishData *dishData = [[DishData alloc] init];
    dishData.motive = motive;
    
    [[APIRequestManager sharedInstance] POST:dishData withURL:[NSString stringWithFormat:kDishFlagUrl, dishId] andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

-(void)deleteDishWithId:(NSString*)dishId completion:(void (^)(BOOL success, APIResponse *response))completion{
    [[APIRequestManager sharedInstance] DELETE:nil withURL:[NSString stringWithFormat:kDishDeleteURL, dishId] andAuthorization:_authToken responseClass:[APIResponse class] ignoringParams:nil completion:^(BOOL success, APIResponse *response) {
        if (success) {
            completion(YES, response);
        } else {
            completion(NO, response);
        }
    }];
}

#pragma mark - Category List Services
-(void)getCategoryListWithCompletion:(void (^)(BOOL success, APIResponse *response))completion{
    [[APIRequestManager sharedInstance] GETwithURL:kCategoriesURL andAuthorization:_authToken responseClass:[APIResponse class] completion:^(BOOL success, APIResponse*response) {
        if(success){
            NSMutableArray *categories = [[NSMutableArray alloc] init];
            if ([response.categories respondsToSelector:@selector(count)]) {
                for (CategoryItem *categoryData in response.categories)
                    [categories addObject:[Category categoryWithCategoryData:categoryData]];
                [CDHelper save];
            }
            response.results = [CDHelper sortArray:categories by:@"name" ascending:YES];
            completion(YES, response);
        }else{
            NSLog(@"failure");
            completion(NO, nil);
        }
    }];
}

-(void)getCategoryTreeListWithCompletion:(void (^)(BOOL success, NSArray *categories))completion{
    [[APIRequestManager sharedInstance] GETwithURL:kCategoriesTreeURL andAuthorization:_authToken responseClass:[CategoryTree class] completion:^(BOOL success, CategoryTree*response) {
        if(success){
            [Category clearCategories];
            
            NSMutableArray *categories = [[NSMutableArray alloc] init];
            
            order = 0;
            for(CategoryItem *categoryItem in response.categories){
                Category *category = [Category createWithName:categoryItem.name];
                category.name = categoryItem.name;
                category.order = [NSNumber numberWithInt:order];
                order++;
                
                if([categoryItem.categories respondsToSelector:@selector(count)]){
                    for(NSString *subcategory in categoryItem.categories){
                        Category *child = [Category createWithName:subcategory];
                        child.name = subcategory;
                        child.parent = category;
                        [category addChildrenObject:child];
                    }
                }
                
                [categories addObject:category];
            };
            
            completion(YES, [Category getAllTopLevel]);
        }else{
            NSLog(@"failure");
            completion(NO, nil);
        }
    }];
}

#pragma mark - NewsFeedData Services
-(void)getNewsFeedWithCompletion:(void (^)(BOOL success, APIResponse *response))completion{
    [[APIRequestManager sharedInstance] GETwithURL:kUserNewsFeed andAuthorization:_authToken responseClass:[APIResponse class] completion:^(BOOL success, APIResponse*response) {
        if(success){
            NSMutableArray *latestActivity = [[NSMutableArray alloc] init];
            if ([response.latestActivity respondsToSelector:@selector(count)]) {
                [NewsFeed clearNewsFeedCompletion:^(BOOL done) {
                    if(done){
                        for (NewsFeedData *newsFeedData in response.latestActivity){
                            [latestActivity addObject:[NewsFeed newsFeedWithNewsFeedData:newsFeedData]];
                        }
                        [CDHelper save];
                    }
                }];
            }
            response.results = [CDHelper sortArray:latestActivity by:@"createdAt" ascending:NO];
            completion(YES, response);
        }else{
            NSLog(@"failure");
            completion(NO, nil);
        }
    }];
}

@end
