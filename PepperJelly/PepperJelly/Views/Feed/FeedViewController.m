//
//  FeedViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTypeCollectionViewCell.h"
#import "UIColor+PepperJelly.h"
#import "RestaurantViewController.h"
#import "APIManager.h"
#import "SearchManager.h"
#import "UIColor+PepperJelly.h"
#import "FilterViewController.h"
#import "FeedCollectionViewCell.h"
#import "FilterViewController.h"
#import "SearchViewController.h"
#import "NotificationManager.h"
#import "UploadedPhotoViewController.h"
#import "ProfileOtherViewController.h"
#import "AlertBadgeView.h"
#import "AlertBadgeProtocol.h"
#import <ClusterPrePermissions/ClusterPrePermissions.h>
#import <Mixpanel/Mixpanel.h>
#import "FilterDetailsViewController.h"
@import MBProgressHUD;

@interface FeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FeedTypeDelegate, CLLocationManagerDelegate, AlertBadgeDelegate> {
    FeedType selectedFeedType;
    BOOL animating;
    BOOL shouldRefreshOnReturn;
    BOOL changeLocation;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *alertButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *currentAddress;
@property (weak, nonatomic) IBOutlet AlertBadgeView *alertBadgeView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic) BOOL mainFeedNeedsRefresh;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainFeedNeedsRefresh = NO;
    
    self.categories = [[NSMutableArray alloc] init];
    self.arrowImageView.hidden = YES;
    
    ClusterPrePermissions *permissions = [ClusterPrePermissions sharedPermissions];
    [permissions showPushNotificationPermissionsWithType:ClusterPushNotificationTypeAlert|ClusterPushNotificationTypeSound|ClusterPushNotificationTypeAlert title:@"Notifications" message:@"Notifications will let you know when other users follow you or like your posts and allow us to send you juicy tips on your favorite places." denyButtonTitle:@"Not Now" grantButtonTitle:@"Give Access" completionHandler:^(BOOL hasPermission, ClusterDialogResult userDialogResult, ClusterDialogResult systemDialogResult) {
        NSLog(@"Push notification consent given: %d", hasPermission);
    }];
    
    //disables so we can enable it in the child scrollviews
    self.collectionView.scrollsToTop = false;
    
    if(![[APIManager sharedInstance].user.useCustomLocation boolValue]){
        [self getUsersCurrentLocation];
        
//        [permissions showLocationPermissionsForAuthorizationType:ClusterLocationAuthorizationTypeWhenInUse title:@"Location" message:@"PepperJelly uses your location to locate properties nearby your current location." denyButtonTitle:@"Not Now" grantButtonTitle:@"Give Access" completionHandler:^(BOOL hasPermission, ClusterDialogResult userDialogResult, ClusterDialogResult systemDialogResult) {
//            if (hasPermission) {
//                [self getUsersCurrentLocation];
//                NSLog(@"current location");
//            } else {
//                [APIManager showAlertWithTitle:@"Location Access Denied" message:@"Please go to the settings and grant Pepperjelly with location authorization to view restaurants around you." viewController:self];
//            }
//        }];
    }else{
        NSLog(@"custom location");
        [self updateFeedType:FeedAll shouldScroll:true];
        [self.collectionView reloadData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppDidBecomeActiveNotification:) name:@"AppDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncomingPushNotifications:) name:REMOTE_PUSH_INACTIVE_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncomingActivePushNotifications:) name:REMOTE_PUSH_ACTIVE_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncomingActivePushNotifications:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];

    
    //[self configureCustomNavBarButonItems];
    
    //Check incoming push notifications
    if([NotificationManager sharedManager].userEnteredAppFrtomRemoreNotification){
        [self handleIncomingPushNotifications:nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"badge count: %lu", (long)[UIApplication sharedApplication].applicationIconBadgeNumber);

    if(shouldRefreshOnReturn){
        NSLog(@"Refreshing collection view on return.");
        [self.collectionView reloadData];
    }
    
    [self showAlertBadge];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIColor imageFromColor:[UIColor navigationBarColor]] forBarMetrics:UIBarMetricsDefault];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void)showAlertBadge{
    if([self shouldShowAlertBadge]){
        [self.navigationController.navigationBar setBackgroundImage:[UIColor imageFromColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
        self.alertBadgeView.hidden = false;
        self.alertBadgeView.delegate = self;
        [self.alertBadgeView showWithBadgeCount:[UIApplication sharedApplication].applicationIconBadgeNumber];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIColor imageFromColor:[UIColor navigationBarColor]] forBarMetrics:UIBarMetricsDefault];
        self.alertBadgeView.hidden = true;
        [self.alertBadgeView hide];
    }
}

-(bool)shouldShowAlertBadge{
    if([UIApplication sharedApplication].applicationIconBadgeNumber > 0){
        return true;
    }else{
        return false;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[RestaurantViewController class]]){
        ((RestaurantViewController*)segue.destinationViewController).dish = sender;
    }else if([segue.identifier isEqualToString:@"showFilterSegue"]){
        shouldRefreshOnReturn = true;
        
        if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *navigationController = segue.destinationViewController;
            if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[FilterViewController class]]){
                ((FilterViewController*)[navigationController.viewControllers objectAtIndex:0]).changeLocationOnOpen = changeLocation;
            }
        }
        changeLocation = false;
        
    }else if([segue.identifier isEqualToString:@"showProfileSegue"]){
        shouldRefreshOnReturn = true;
    }else if([segue.identifier isEqualToString:@"profileOtherSegue"]){
        if([segue.destinationViewController isKindOfClass:[ProfileOtherViewController class]]){
            ((ProfileOtherViewController*)segue.destinationViewController).user = sender;
        }
    } else if([segue.identifier isEqualToString:@"uploadedPhotoSegue"]){
        UINavigationController *navigationController = segue.destinationViewController;
        if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[UploadedPhotoViewController class]]){
            if([sender isKindOfClass:[Dish class]])
                ((UploadedPhotoViewController*)[navigationController.viewControllers objectAtIndex:0]).dish = sender;
        }
    } else if ([segue.identifier isEqualToString:@"CategorySegue"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        FilterDetailsViewController *categoryController = navController.viewControllers[0];
        categoryController.delegate = sender;
        
        CategoryItem *categoryItem = [[CategoryItem alloc] initWithName:NSLocalizedString(@"Categories", @"")];
        
        for(CategoryItem *category in self.categories)
            [categoryItem.subcategoriesToShow addObjectsFromArray:category.subcategoriesToShow];
        categoryController.categoryItem = categoryItem;
    }

}

-(IBAction)unwindToFeed:(UIStoryboardSegue*)sender{
    [self.collectionView reloadData];
}

#pragma mark - Events
-(void)handleIncomingActivePushNotifications:(NSNotification *)note{
    [self showAlertBadge];
}

-(void)handleIncomingPushNotifications:(NSNotification *)note{
    if([NotificationManager sharedManager].userEnteredAppFrtomRemoreNotification){
        //Check Push type
        if([NotificationManager sharedManager].dishId.length > 0){
            [[APIManager sharedInstance] getDishWithId:[NotificationManager sharedManager].dishId completion:^(BOOL success, Dish *response) {
                if(success){
                    if(response)
                        [self performSegueWithIdentifier:@"uploadedPhotoSegue" sender:response];
                }
            }];
        }else{
            if([NotificationManager sharedManager].userId.length > 0){
                [[APIManager sharedInstance] getUserWithUserId:[NotificationManager sharedManager].userId completion:^(BOOL success, User *user) {
                    if(success){
                        if(user)
                            [self performSegueWithIdentifier:@"profileOtherSegue" sender:user];
                    }
                }];
            }
        }
    }
}

- (void)handleAppDidBecomeActiveNotification:(NSNotification *)notification {
    // Refresh
    [self.collectionView reloadData];
}

-(void)getUsersCurrentLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self updateFeedType:FeedAll shouldScroll:true];
        // [self.collectionView reloadData];
    }
}

- (IBAction)publishButtonPressed:(id)sender {
}

-(IBAction)profileBtnTapped:(id)sender{
    [self performSegueWithIdentifier:@"showProfileSegue" sender:nil];
}

-(IBAction)filterBtnTapped:(id)sender{
    [self performSegueWithIdentifier:@"showFilterSegue" sender:nil];
}

- (IBAction)searchButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"searchSegue" sender:nil];
}

- (IBAction)alertButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"newsFeedSegue" sender:nil];
}


- (IBAction)allButtonPressed:(id)sender {
    self.mainFeedNeedsRefresh = YES;
    [self updateFeedType:FeedAll shouldScroll:true];
}

- (IBAction)followingButtonPressed:(id)sender {
    [self updateFeedType:FeedFollowing shouldScroll:true];
}

- (void)updateFeedType:(FeedType)type shouldScroll:(BOOL)shouldScroll{
    if(animating)
        return;
    animating = true;
    
    selectedFeedType = type;
    
    if(shouldScroll)
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedFeedType inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    switch (selectedFeedType) {
        case FeedAll:
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.allButton.backgroundColor = [UIColor pepperjellyPinkColor];
                self.followingButton.backgroundColor = [UIColor clearColor];
                [self.allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.followingButton setTitleColor:[UIColor greyishBrownColor] forState:UIControlStateNormal];
            }completion:^(BOOL finished) {
                animating = false;
                if (self.mainFeedNeedsRefresh) {
                    self.mainFeedNeedsRefresh = NO;
                    self.arrowImageView.hidden = YES;
                    [self.allButton setTitle:@"I'M CRAVING" forState:UIControlStateNormal];
                    FeedTypeCollectionViewCell *cell = (FeedTypeCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                    cell.selectedMenuOption = MenuOptionNone;
                    [cell syncronize];
                }
            }];
        }
            break;
        case FeedFollowing:
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.followingButton.backgroundColor = [UIColor pepperjellyPinkColor];
                self.allButton.backgroundColor = [UIColor clearColor];
                [self.followingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.allButton setTitleColor:[UIColor greyishBrownColor] forState:UIControlStateNormal];
            }completion:^(BOOL finished) {
                animating = false;
            }];
        }
            break;
    }
}

#pragma mark - CollectionView Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"feedType" forIndexPath:indexPath];
    cell.feedTypeDelegate = self;
    cell.feedType = indexPath.row == 0 ? FeedAll : FeedFollowing;
    
    if(shouldRefreshOnReturn || cell.feeds.count == 0){
        cell.page = 0;
        [cell syncronize];
    }
    shouldRefreshOnReturn = false;

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, collectionView.frame.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPage = ((self.collectionView.contentOffset.x+self.collectionView.frame.size.width/2) / self.collectionView.frame.size.width);
    
    if(currentPage >= 0 && currentPage < 2)
        [self updateFeedType:currentPage shouldScroll:false];
    
    [self.alertBadgeView hide];
}

#pragma mark - FeedType delegate

-(void)openFeed:(Dish *)feed sender:(id)sender frame:(CGRect)frame{
    
    FeedCollectionViewCell *cell = sender;
    /*
    frame.origin.y += self.collectionView.frame.origin.y;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = cell.imageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = true;
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.5f animations:^{
        imageView.frame = CGRectMake(0, 64, self.collectionView.frame.size.width, self.collectionView.frame.size.width);
        self.collectionView.alpha = 0;
        self.allButton.alpha = 0;
        self.followingButton.alpha = 0;
    }completion:^(BOOL finished) {        
        RestaurantViewController *restaurantViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Restaurant"];
        restaurantViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        restaurantViewController.dish = feed;
        restaurantViewController.selectedImage = imageView.image;
        [self.navigationController pushViewController:restaurantViewController animated:NO];
        
        [imageView removeFromSuperview];
        self.collectionView.alpha = 1;
        self.allButton.alpha = 1;
        self.followingButton.alpha = 1;
    }];
    */
    //[self performSegueWithIdentifier:@"restaurantSegue" sender:feed];
    
    RestaurantViewController *restaurantViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Restaurant"];
    restaurantViewController.dish = feed;
    restaurantViewController.selectedImage = cell.imageView.image;
    [self.navigationController pushViewController:restaurantViewController animated:YES];
}

-(void)changeLocation{
    changeLocation = true;
    [self performSegueWithIdentifier:@"showFilterSegue" sender:nil];
}

-(void)feedDidScroll{
    [self.alertBadgeView hide];
}

- (void)mainMenuOptionSelected {
    self.arrowImageView.hidden = NO;
    [self.allButton setTitle:@"RESET" forState:UIControlStateNormal];
}

#pragma CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    NSLog(@"Received location manager update.");
    if (fabs(howRecent) < 15.0) {
        NSLog(@"Updating address location. Lat: %1.5f. Long: %1.5f", location.coordinate.latitude, location.coordinate.longitude);
        [self.locationManager stopUpdatingLocation];
        [self updateAddressLocation:location];
        [APIManager sharedInstance].currentLocation = location;
        
        [self.collectionView reloadData];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //[self.view stopLoading];
    
    if( error == kCLErrorLocationUnknown ) {
        NSLog(@"location services error: %@", error);
    }
    
    //[APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_location", @"") viewController:self];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"error getting location: %@", [error localizedDescription]);
}

- (void)updateAddressLocation:(CLLocation *)location {
    [[SearchManager searchManager] reverseGeocodeByLocation:location andCompletionHandler:^(NSString *address, NSError *error){
        if (error) {
            self.currentAddress = nil;
        } else {
            self.currentAddress = address;
            NSLog(@"ADDRESS: %@", self.currentAddress);
        }
        
        //[self.view stopLoading];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self checkLocationServicesPermissions];
}

/* This Method is the called by the delegate method for CoreLocation. It displays error messages if the user changes location authorization*/
- (void)checkLocationServicesPermissions {
    
    if( [CLLocationManager locationServicesEnabled] ) {
        
        //check on location services permissions
        switch( [CLLocationManager authorizationStatus] ) {
                //shown on initial app install - the user hasn't made a decision yet
            case kCLAuthorizationStatusNotDetermined: {
                NSLog(@"location not determined");
                //[self.view stopLoading];
                break;
            }
                //the device has parental controls enabled
            case kCLAuthorizationStatusRestricted: {
                NSLog(@"location restricted");
                //[self.view stopLoading];
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_location", @"") viewController:self];
                break;
            }
                
                //user explicitly denied location services
            case kCLAuthorizationStatusDenied: {
                //[self.view stopLoading];
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_location", @"") viewController:self];
                break;
            }
                
                //otherwise, we are authorized...
                //so really, do nothing.
            default: {
                break;
            }
        }
    }
    
    //location services are not enabled - what do we do now? Just display an error.
    else {
        //[self.view stopLoading];
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_location_permissions", @"") viewController:self];
    }
}

- (void)showFiltersWithSender:(id)sender {
    // TODO
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[APIManager sharedInstance] getCategoryTreeListWithCompletion:^(BOOL success, NSArray* categories) {
        [hud hideAnimated:YES];
        if(success){
            [self.categories removeAllObjects];
            for (Category *category in categories) {
                [self.categories addObject:[[CategoryItem alloc] initWithCategory:category selectedSubcategories:@[]]];
            }
            [self performSegueWithIdentifier:@"CategorySegue" sender:sender];
        }else{
            [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_get_categories_list", @"") viewController:self];
        }
    }];
}


#pragma mark - AlertBadgeDelegate Methdos
-(void)userPressedBadge{
    NSLog(@"user tapped badge");
    [self alertButtonPressed:nil];
}


@end
