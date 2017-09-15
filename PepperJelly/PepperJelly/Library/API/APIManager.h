
//
//  APIManagerExample.h
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "APIResponse.h"
#import "CDHelper.h"
#import "User.h"
#import "Restaurant.h"
#import "Search.h"
#import "Dish.h"
#import "Comment.h"
#import "Report.h"
#import "UserModify.h"
#import <CoreLocation/CoreLocation.h>


/*** AWS STAGING ***/
/*
#define kBaseURL        @"http://dtm-dev-01.dogtownmedia.com:3003"
#define kAWSAccessKey   @"AKIAIWZIE66IS3XBQBKQ"
#define kAWSSecretKey   @"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"
#define kAWSBucket      @"pepperjelly-images"
#define kAWSURL         @"https://pepperjelly-images.s3-us-west-1.amazonaws.com/users"
#define kAWSServer      AWSRegionUSWest1
*/

/*** AWS PRODUCTION ***/
//#define kBaseURL        @"https://go.pepperjellyapp.com"
#define kBaseURL        @"https://pepperjelly-staging.herokuapp.com"
#define kAWSAccessKey   @"AKIAI2CI5Z4DO33KFHTA"
#define kAWSSecretKey   @"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"
#define kAWSBucket      @"pepperjelly-images-prod"
#define kAWSURL         @"https://pepperjelly-images-prod.s3-us-west-2.amazonaws.com/users"
#define kAWSURLBase     @"https://pepperjelly-images-prod.s3-us-west-2.amazonaws.com/"
#define kAWSServer      AWSRegionUSWest2

/*** CLOUDINARY PRODUCTION ***/
#define kCloudinaryCloudName    @"pepperjelly"
#define kCloudinaryApiKey       @"443841118836458"
#define kCloudinaryApiSecret    @"tI0E2FWrsF-o0qQHvovhYtLM9UQ"
#define kCloudinaryURL          @"cloudinary://443841118836458:tI0E2FWrsF-o0qQHvovhYtLM9UQ@pepperjelly"

/*** URLs ***/
#define kUserRegisterURL        kBaseURL @"/api/v1/user/register"
#define kUserLoginURL           kBaseURL @"/api/v1/user/login"
#define kUserPasswordURL        kBaseURL @"/api/v1/user/password"
#define kUserForgotPasswordURL  kBaseURL @"/api/v1/user/forgot"
#define kUserModifyURL          kBaseURL @"/api/v1/profile"
#define kUserSearchURL          kBaseURL @"/api/v1/user/search"
#define kUserGetURL             kBaseURL @"/api/v1/user/get"
#define kUserReportURL          kBaseURL @"/api/v1/user/report"
#define kUserFollowURL          kBaseURL @"/api/v1/user/follow"
#define kUserUnfollowURL        kBaseURL @"/api/v1/user/unfollow"
#define kUserGetFollowersURL    kBaseURL @"/api/v1/user/getFollowers"
#define kUserGetFollowingURL    kBaseURL @"/api/v1/user/getFollowing"
#define kUserFBLoginUrl         kBaseURL @"/api/v1/user/fbtoken"
#define kUserGoogleLoginUrl     kBaseURL @"/api/v1/user/googleOAuth"
#define kUserBlock              kBaseURL @"/api/v1/user/block"
#define kRestaurantGetUrl       kBaseURL @"/api/v1/restaurants"
#define kDishCreateUrl          kBaseURL @"/api/v1/dish"
#define kDishLikeUrl            kBaseURL @"/api/v1/dish/%@/like"
#define kDishCommentUrl         kBaseURL @"/api/v1/dish/%@/comment"
#define kDishGetUrl             kBaseURL @"/api/v1/dish/%@"
#define kDishSearchUrl          kBaseURL @"/api/v1/dish/search"
#define kDishFlagUrl            kBaseURL @"/api/v1/dish/%@/flag"
#define kDishFeed               kBaseURL @"/api/v1/feed"
#define kDishDeleteURL          kBaseURL @"/api/v1/dish/%@"
#define kDishLikedUrl           kBaseURL @"/api/v1/liked"
#define kCategoriesURL          kBaseURL @"/api/v1/categories"
#define kCategoriesTreeURL      kBaseURL @"/api/v1/categories/tree"
#define kSearchPlace            kBaseURL @"/api/v1/autocomplete"
#define kUserNewsFeed           kBaseURL @"/api/v1/user/feed"


@interface APIManager : NSObject{
    int order;
}

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL offlineMode;
@property (nonatomic, assign) BOOL didShowTutorialForRestaurant;

+ (APIManager *)sharedInstance;

#pragma mark - UserDefaults

-(void)saveDefaults;
-(void)loadDefaults;
-(void)logoutUser;
-(BOOL)isLoggedIn;

#pragma mark - Validations

+(BOOL)isValidEmail:(NSString*)email;
+(BOOL)isValidPassword:(NSString*)password;
+(BOOL)isValidName:(NSString*)name;
+(BOOL)isValidUserName:(NSString *)username;

#pragma mark - Alerts

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message viewController:(UIViewController*)viewController;

#pragma mark - Account Services

-(void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)signUpWithName:(NSString*)name email:(NSString*)email password:(NSString*)password completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)forgotPasswordWithEmail:(NSString*)email completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)changePassword:(NSString *)password completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)modifyUser:(UserModify*)userModify completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)userRegisterWithFacebookToken:(NSString *)token completionHandler:(void (^)(BOOL success, APIResponse *response))completion;
-(void)userRegisterWithGoogleId:(NSString *)_id email:(NSString *)email name:(NSString *)name userPicture:(NSString *)userPic completionHandler:(void (^)(BOOL success, APIResponse *obj))completion;
-(void)userReportUserWithID:(NSString *)userid reason:(NSString *)reason completionHandler:(void (^)(BOOL success, APIResponse *obj))completion;
-(void)userBlockUserWithID:(NSString *)userid completionHandler:(void (^)(BOOL success, APIResponse *obj))completion;

#pragma mark - AWS Services

-(void)userUploadPhoto:(UIImage *)photo completionHandler:(void (^)(BOOL success, NSString *url))completion;
-(void)userUploadPhoto:(UIImage *)photo withSizes:(NSArray*)sizes urls:(NSArray*)urls completionHandler:(void(^)(BOOL success, NSMutableArray *imageURLS))completionHandler;

#pragma mark - Search Services

-(void)searchUsersWithSearch:(Search *)search completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)getUserWithUserName:(NSString*)userName completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)getUserWithUserId:(NSString *)userId completion:(void (^)(BOOL success, User *user))completion;

#pragma mark - Follow Services

-(void)followUserWithId:(NSString*)userId completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)unfollowUserWithId:(NSString*)userId completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)getFollowersWithUser:(User*)user completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)getFollowingWithUser:(User*)user completion:(void (^)(BOOL success, APIResponse *response))completion;

#pragma mark - Restaurant Services

-(void)getRestaurantsWithCompletion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)getRestaurantWithId:(NSString*)restaurantId completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)searchRestaurantsWithSearch:(Search *)search completion:(void (^)(BOOL success, APIResponse *response))completion;

#pragma mark - Dish Services
-(void)createDishWithImage:(NSArray*)image googleplaceId:(NSString *)googleplaceId caption:(NSString *)caption categories:(NSArray *)categories rating:(NSNumber *)rating completion:(void (^)(BOOL, APIResponse *))completion;
-(void)getDishesFeedWithSearch:(Search*)search completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)createDishWithImage:(NSString*)image restaurantId:(NSString*)restaurantId caption:(NSString*)caption categories:(NSArray*)categories rating:(NSNumber *)rating completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)likeDishWithId:(NSString*)dishId like:(BOOL)like completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)commentDishWithId:(NSString*)dishId comment:(NSString*)comment completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)getDishWithId:(NSString*)dishId completion:(void (^)(BOOL success, Dish *response))completion;
-(void)getLikedDishesWithCompletion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)searchDishesWithSearch:(Search*)search completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)flagDishWithId:(NSString*)dishId motive:(NSString*)motive completion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)deleteDishWithId:(NSString*)dishId completion:(void (^)(BOOL success, APIResponse *response))completion;

#pragma mark - Category services
-(void)getCategoryListWithCompletion:(void (^)(BOOL success, APIResponse *response))completion;
-(void)getCategoryTreeListWithCompletion:(void (^)(BOOL success, NSArray *categories))completion;

#pragma mark - Search Google Places API
-(void)searchRestaurantWithInput:(NSString *)input latitude:(float)latitude longitude:(float)longitude  radius:(float)radius completionHandler:(void (^)(BOOL success, APIResponse *response))completion;

#pragma mark - NewsFeedData Services
-(void)getNewsFeedWithCompletion:(void (^)(BOOL success, APIResponse *response))completion;
@end
