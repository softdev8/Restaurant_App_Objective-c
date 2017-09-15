//
//  FeedTypeCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PepperJelly-Swift.h" // Imports all swift files
#import "MainMenuOptionCollectionViewCell.h"
#import "FeedTypeCollectionViewCell.h"
#import "FeedCollectionViewCell.h"
#import "UIColor+PepperJelly.h"
#import "APIManager.h"
#import "UIView+Loading.h"
#import "UIImage+Online.h"
#import "UICollectionViewCell+Online.h"
#import "UserCategory.h"
#import "FeedSearch.h"
#import "NotificationManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
@import CoreLocation;
#import <ClusterPrePermissions/ClusterPrePermissions.h>
#import "FilterDetailsViewController.h"
#import <Mixpanel/Mixpanel.h>
#import <SDWebImage/SDWebImagePrefetcher.h>

#define feedsItems 2
#define feedsSpacing 1.5

@interface FeedTypeCollectionViewCell () <EmptyMessageDelegate, CLLocationManagerDelegate, FindCategoryDelegate>

@property (strong, nonatomic) NSArray *mainMenuOptions;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *categories;

@end

@implementation FeedTypeCollectionViewCell

-(void)awakeFromNib{
    
    self.mainMenuOptions = @[
                             @{
                                 @"title": @"NEAR ME",
                                 @"image": @"nearme"
                                 },
                             @{
                                 @"title": @"ITALIAN",
                                 @"image": @"italian"
                                 },
                             @{
                                 @"title": @"BREAKFAST",
                                 @"image": @"breakfast"
                                 },
                             @{
                                 @"title": @"SANDWICHES",
                                 @"image": @"sandwich"
                                 },
                             /*
                             @{
                                 @"title": @"HEATING UP",
                                 @"image": @"heatingup"
                                 },
                              */
                             @{
                                 @"title": @"SUSHI",
                                 @"image": @"sushi"
                                 },
                             @{
                                 @"title": @"MEXICAN",
                                 @"image": @"mexican"
                                 },
                             @{
                                 @"title": @"BURGERS",
                                 @"image": @"burgers"
                                 },
                             @{
                                 @"title": @"DRINKS",
                                 @"image": @"drinks"
                                 },
                             @{
                                 @"title": @"COFFEE / TEA",
                                 @"image": @"coffee"
                                 },
                             @{
                                 @"title": @"DESSERTS",
                                 @"image": @"desserts"
                                 },
                             @{
                                 @"title": @"HEALTHY",
                                 @"image": @"healthy"
                                 },
                             @{
                                 @"title": @"VEGETARIAN FRIENDLY",
                                 @"image": @"vegetarian"
                                 },
                             @{
                                 @"title": @"PIZZA",
                                 @"image": @"pizza"
                                 },
                             @{
                                 @"title": @"NOODLES",
                                 @"image": @"noodles"
                                 },
                             @{
                                 @"title": @"FIND",
                                 @"image": @"find"
                                 },
                             @{
                                 @"title": @"VIEW ALL",
                                 @"image": @"viewall"
                                 }
                             ];
    
    self.selectedMenuOption = MenuOptionNone;
    //enable to scrolltotop when tap on statusbar
    self.collectionView.scrollsToTop = true;
    
    self.feeds = [[NSMutableArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor pepperjellyPinkColor];
    [self.refreshControl addTarget:self action:@selector(syncronize) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.refreshControl.enabled = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.canLoadMore = true;
    //[self syncronize];
}

-(void)syncronize{
    
    if (self.selectedMenuOption == MenuOptionNone && self.feedType == FeedAll) {
        // User has not yet selected a main menu option.
        self.page = 0;
        self.canLoadMore = YES;
        [self.collectionView reloadData];
        return;
    }
    
    if(!self.refreshControl.refreshing && ![self isLoading]){
        [self startLoading];
    }else{
        //reset page if refreshed list
        self.page = 0;
    }
    
    //sets what to search
    Search *search = [[Search alloc] init];
    if (self.feedType == FeedFollowing || self.selectedMenuOption == MenuOptionViewAll) {
        search.range = [[APIManager sharedInstance].user.locationRange doubleValue] > MAX_RANGE ? [NSNumber numberWithInt:MAX_RANGE] : [APIManager sharedInstance].user.locationRange;
        if (![[APIManager sharedInstance].user.useCustomLocation boolValue] && [APIManager sharedInstance].currentLocation.coordinate.latitude != 0 && [APIManager sharedInstance].currentLocation.coordinate.longitude != 0) {
            // Search based off of current location
            NSLog(@"Searching with current location.");
            search.latitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.latitude];
            search.longitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.longitude];
        } else {
            // Search based off of the saved user location
            NSLog(@"Searching with custom location.");
            search.latitude = [APIManager sharedInstance].user.locationLatitude;
            search.longitude = [APIManager sharedInstance].user.locationLongitude;
        }
    } else if (self.selectedMenuOption == MenuOptionFind) {
        search.range = [[APIManager sharedInstance].user.locationRange doubleValue] > MAX_RANGE ? [NSNumber numberWithInt:MAX_RANGE] : [APIManager sharedInstance].user.locationRange;
        if (![[APIManager sharedInstance].user.useCustomLocation boolValue] && [APIManager sharedInstance].currentLocation.coordinate.latitude != 0 && [APIManager sharedInstance].currentLocation.coordinate.longitude != 0) {
            // Search based off of current location
            NSLog(@"Searching with current location.");
            search.latitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.latitude];
            search.longitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.longitude];
        } else {
            // Search based off of the saved user location
            NSLog(@"Searching with custom location.");
            search.latitude = [APIManager sharedInstance].user.locationLatitude;
            search.longitude = [APIManager sharedInstance].user.locationLongitude;
        }
        
        search.category = self.categories;
    } else if (self.selectedMenuOption == MenuOptionNearMe) {
        search.range = [NSNumber numberWithInt:NEAR_ME_RANGE];
        if ([APIManager sharedInstance].currentLocation.coordinate.latitude != 0 && [APIManager sharedInstance].currentLocation.coordinate.longitude != 0) {
            // Search based off of current location
            NSLog(@"Searching with current location.");
            search.latitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.latitude];
            search.longitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.longitude];
        } else {
            ClusterPrePermissions *permissions = [ClusterPrePermissions sharedPermissions];
            [permissions showLocationPermissionsForAuthorizationType:ClusterLocationAuthorizationTypeWhenInUse title:@"Location" message:@"PepperJelly uses your location to locate properties nearby your current location." denyButtonTitle:@"Not Now" grantButtonTitle:@"Give Access" completionHandler:^(BOOL hasPermission, ClusterDialogResult userDialogResult, ClusterDialogResult systemDialogResult) {
                if (hasPermission) {
                    [self getUsersCurrentLocation];
                    NSLog(@"current location");
                } else {
                    [APIManager showAlertWithTitle:@"Location Access Denied" message:@"Please go to the settings and grant Pepperjelly with location authorization to view restaurants around you." viewController:self.feedTypeDelegate];
                }
            }];
            return;
        }
    } else {
        search.range = [[APIManager sharedInstance].user.locationRange doubleValue] > MAX_RANGE ? [NSNumber numberWithInt:MAX_RANGE] : [APIManager sharedInstance].user.locationRange;
        if (![[APIManager sharedInstance].user.useCustomLocation boolValue] && [APIManager sharedInstance].currentLocation.coordinate.latitude != 0 && [APIManager sharedInstance].currentLocation.coordinate.longitude != 0) {
            // Search based off of current location
            NSLog(@"Searching with current location.");
            search.latitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.latitude];
            search.longitude = [NSNumber numberWithDouble:[APIManager sharedInstance].currentLocation.coordinate.longitude];
        } else {
            // Search based off of the saved user location
            NSLog(@"Searching with custom location.");
            search.latitude = [APIManager sharedInstance].user.locationLatitude;
            search.longitude = [APIManager sharedInstance].user.locationLongitude;
        }
        
        if (self.selectedMenuOption == MenuOptionItalian) {
            search.category = @[@"Italian"];
        } else if (self.selectedMenuOption == MenuOptionBreakfast) {
            search.category = @[@"Breakfast"];
        } else if (self.selectedMenuOption == MenuOptionSushi) {
            search.category = @[@"Sushi"];
        } else if (self.selectedMenuOption == MenuOptionMexican) {
            search.category = @[@"Mexican"];
        } else if (self.selectedMenuOption == MenuOptionSandwiches) {
            search.category = @[@"Sandwiches"];
        } else if (self.selectedMenuOption == MenuOptionBurgers) {
            search.category = @[@"Burgers"];
        } else if (self.selectedMenuOption == MenuOptionDrinks) {
            search.category = @[@"Drinks"];
        } else if (self.selectedMenuOption == MenuOptionCoffeeTea) {
            search.category = @[@"Coffee (& Tea)", @"Tea"];
        } else if (self.selectedMenuOption == MenuOptionDesserts) {
            search.category = @[@"Desserts"];
        } else if (self.selectedMenuOption == MenuOptionHealthy) {
            search.category = @[@"Healthy"];
        } else if (self.selectedMenuOption == MenuOptionVegetarian) {
            search.category = @[@"Liked by Vegetarians", @"Vegetarian"];
        } else if (self.selectedMenuOption == MenuOptionPizza) {
            search.category = @[@"Pizza"];
        } else if (self.selectedMenuOption == MenuOptionNoodles) {
            search.category = @[@"Noodles"];
        }
    }
    
    search.onlyFollowed = [NSNumber numberWithBool:(self.feedType == FeedFollowing)];
    search.$skip = [NSNumber numberWithInteger:self.page*FEED_PAGING_AMOUNT];
    search.$limit = [NSNumber numberWithInteger:FEED_PAGING_AMOUNT];
    search.deviceToken = [NotificationManager sharedManager].deviceToken;
    
    NSLog(@"device token: %@", [NotificationManager sharedManager].deviceToken);
    
    [[APIManager sharedInstance] getDishesFeedWithSearch:search completion:^(BOOL success, APIResponse *response) {
        [self.refreshControl endRefreshing];
        [self stopLoading];
        
        //only continue if something has changed
        if([response.results isEqualToArray:self.feeds]){
            if(response.results.count == 0)
                [self.collectionView reloadData];
                
            return;
        }
        
        //makes sure it doesn't clear the list if it's paging
        if(!isPaging)
            [self.feeds removeAllObjects];
        self.canLoadMore = true;
        
        //only add if has more results, otherwise will not let update
        if(response.results.count > 0)
            [self.feeds addObjectsFromArray:response.results];
        else
            self.canLoadMore = false;
        
        

        
        [self.collectionView reloadData];
        
        //scrolls to new items after reload
        if(isPaging && self.feeds.count > self.page*FEED_PAGING_AMOUNT) {
            // Disable automatic scrolling
            //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.page*FEED_PAGING_AMOUNT inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        } else if(!isPaging && self.page == 0 && self.feeds.count > 0) {
            if(self.collectionView.contentOffset.y != 0)
                self.canLoadMore = false;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        }
        
        isPaging = false;
        
        //save feeds for fast recovery
        [FeedSearch saveFeedSearchWithDishes:self.feeds following:(self.feedType == FeedFollowing)];
    }];
}

-(void)getUsersCurrentLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    NSLog(@"Received location manager update.");
    if (fabs(howRecent) < 15.0) {
        NSLog(@"Updating address location. Lat: %1.5f. Long: %1.5f", location.coordinate.latitude, location.coordinate.longitude);
        [self.locationManager stopUpdatingLocation];
        [APIManager sharedInstance].currentLocation = location;
        [self syncronize];
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

-(void)nextPage{
    if(!self.canLoadMore)
        return;
    
    self.page++;
    self.canLoadMore = false;
    isPaging = true;
    
    [self syncronize];
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.selectedMenuOption == MenuOptionNone && self.feedType == FeedAll) {
        [self hideMessage];
        return [self.mainMenuOptions count];
    }
    
    if(self.feeds.count == 0){
        //if it's following and there are no following users for current user
        if((self.feedType == FeedFollowing) && [APIManager sharedInstance].user.followingUsers.count == 0)
            [self showMessageWithText:NSLocalizedString(@"empty_following", @"")];
        //in case filters are reset, but still there are no feeds, it means there is no feeds for the current location
        else if([APIManager sharedInstance].user.categories.count == 0 && [[APIManager sharedInstance].user.locationRange doubleValue] >= MAX_RANGE)
            [self showMessageWithText:NSLocalizedString(@"emtpy_feeds_location", @"") actionTitle:NSLocalizedString(@"empty_action_changelocation", @"") delegate:self];
        //otherwise, reset filter
        else
            [self showMessageWithText:NSLocalizedString(@"emtpy_feeds", @"") actionTitle:NSLocalizedString(@"empty_action_resetfilter", @"") delegate:self];
    }else
        [self hideMessage];
    
    return self.feeds.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedMenuOption == MenuOptionNone && self.feedType == FeedAll) {
        MainMenuOptionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"menuOption" forIndexPath:indexPath];
        NSDictionary *mainMenuOptionInfo = self.mainMenuOptions[indexPath.item];
        cell.menuOptionTitle.text = mainMenuOptionInfo[@"title"];
        cell.menuOptionImageView.image = [UIImage imageNamed:mainMenuOptionInfo[@"image"]];
        return cell;
    }
    
    FeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"feed" forIndexPath:indexPath];
    
    Dish *dish = [self.feeds objectAtIndex:indexPath.item];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dish.thumbImageUrl] placeholderImage:PJ_IMAGE_PLACEHOLDER];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float size = [[UIScreen mainScreen] bounds].size.width/feedsItems-(feedsSpacing*(feedsItems-1));
    return CGSizeMake(size, size);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedMenuOption == MenuOptionNone && self.feedType == FeedAll) {
        NSLog(@"SELECTED TILE: %@", self.mainMenuOptions[indexPath.row][@"title"]);
        [[Mixpanel sharedInstance] track:@"Main Menu Tile Selected" properties:@{ @"type": self.mainMenuOptions[indexPath.row][@"title"] }];
        if ((MenuOption)(indexPath.item + 1) == MenuOptionFind) {
            // User selected Find option
            [self.feedTypeDelegate showFiltersWithSender:self];
        } else {
            self.selectedMenuOption = (MenuOption)(indexPath.item + 1);
            [self syncronize];
            [self.feedTypeDelegate mainMenuOptionSelected];
        }
        return;
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y-self.collectionView.contentOffset.y, cell.frame.size.width, cell.frame.size.height);
    
    [self.feedTypeDelegate openFeed:[self.feeds objectAtIndex:indexPath.item] sender:cell frame:cellFrame];
}

- (void)handleCategoriesSelected:(NSArray *)categories {
    self.categories = categories;
    self.selectedMenuOption = MenuOptionFind;
    [self.feedTypeDelegate mainMenuOptionSelected];
    [self syncronize];
}

#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.selectedMenuOption == MenuOptionNone && self.feedType == FeedAll) {
        return;
    }
    float y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom;
    if(y > scrollView.contentSize.height + FEED_NEXT_PAGE_OFFSET){
        if(self.canLoadMore){
            [self nextPage];
        }
    }
    
    [self.feedTypeDelegate feedDidScroll];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.selectedMenuOption == MenuOptionNone && self.feedType == FeedAll) {
        return;
    }
    self.canLoadMore = true; // FIX: Maybe this shouldn't be setting canLoadMore to true
}

#pragma mark - Empty message Delegate

-(void)didPressEmptyMessageActionButtonWithText:(NSString *)text{
    if([text isEqualToString:NSLocalizedString(@"empty_action_changelocation", @"")]){
        //change location
        if (self.selectedMenuOption == MenuOptionNearMe) {
            self.selectedMenuOption = MenuOptionNone;
            [self syncronize];
            return;
        }
        
        [self.feedTypeDelegate changeLocation];
    } else {
        //reset filter
        UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
        user.range = [NSNumber numberWithInt:MAX_RANGE];
        user.categories = [[NSArray alloc] init];
        
        [self startLoading];
        [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
            [self stopLoading];
        }];
        
        self.selectedMenuOption = MenuOptionNone;
        [self syncronize];
    }
}

@end
