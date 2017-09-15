//
//  Constants.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//----------------------------
#pragma mark - Services

#define TIMEOUT_TIME 10.0f
#define CACHE_CAPACITY_IN_MB 10
#define EXCERPT_MAX_LENGTH 33

#define RESTAURANT_SEARCH_RADIUS 1000

#define FEED_PAGING_AMOUNT 20
#define FEED_NEXT_PAGE_OFFSET 20

#define IMAGE_SIZE_FEED_THUMBNAIL CGSizeMake(250,250)
#define IMAGE_SIZE_FEED_MEDIUM CGSizeMake(640,640)
#define IMAGE_SIZE_FEED_BIG CGSizeMake(1125, 1125)
#define IMAGE_SIZE_PROFILE CGSizeMake(390, 390)

#define PJ_IMAGE_PLACEHOLDER [UIImage imageNamed:@"loading_placeholder"]
#define PJ_IMAGE_LIKE_ANIMATION [UIImage imageNamed:@"loading_placeholder"]

#define EXCERPT(A,B)(A == nil ? @"" : (A.length < B ? [NSString stringWithFormat:@"\"%@\"", A] : [NSString stringWithFormat:@"\"%@...\"", [A substringToIndex:B]]))

// ******************* iOS VERSION MACROS *****************//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// ******************* DEVICE INDENTIFICATION MACROS *****************//
#define IS_IPAD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE4          (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE5          (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE6          (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE6PLUS      (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA           ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

// ******************* DistanceSlider *****************//
#define DISTANCE_SLIDER_1 1.5
#define DISTANCE_SLIDER_2 2.5
#define DISTANCE_SLIDER_3 3.5
#define DISTANCE_SLIDER_4 4.5
#define DISTANCE_SLIDER_5 5

#define DISTANCE_SLIDER_VALUE_1 800
#define DISTANCE_SLIDER_VALUE_2 8000
#define DISTANCE_SLIDER_VALUE_3 16000
#define DISTANCE_SLIDER_VALUE_4 40000
#define DISTANCE_SLIDER_VALUE_5 80000

#define MAX_RANGE 16093
#define NEAR_ME_RANGE 3218

typedef NS_ENUM(NSInteger, DistanceSliderOption) {
    DistanceSliderOption1 = 1,
    DistanceSliderOption2 = 2,
    DistanceSliderOption3 = 3,
    DistanceSliderOption4 = 4,
    DistanceSliderOption5 = 5
};

// ******************* Leave Review on App store *****************//
#define APP_ID 1113913104
static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=";

// ******************* Feedback Email *****************//
static NSString *const feedbackEmail = @"team@pepperjellyapp.com";

// ******************* Push notification *****************//
#define REMOTE_PUSH_INACTIVE_STATE @"remote_push_while_inactive_state"
#define REMOTE_PUSH_ACTIVE_STATE @"remote_push_while_active_state"


#endif /* Constants_h */
