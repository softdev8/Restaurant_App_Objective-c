//
//  SingleViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantViewController.h"
#import "BannerViewCell.h"
#import "RestaurantPhotoTableViewCell.h"
#import "RestaurantPhotoDetailsTableViewCell.h"
#import "RestaurantHeaderTableViewCell.h"
#import "RestaurantHeaderDetailsTableViewCell.h"
#import "RestaurantHeaderDetailsTimeTableViewCell.h"
#import "RestaurantHeaderDetailsSaveTableViewCell.h"
#import "RestaurantGalleryTableViewCell.h"
#import "RestaurantProtocols.h"
#import "UIView+Loading.h"
#import "UIImage+Online.h"
#import "APIManager.h"
#import "OpeningTime.h"
#import "Category.h"
#import "ProfileOtherViewController.h"
#import "UITableViewCell+Online.h"
#import "GalleryPhotoViewController.h"
#import "MoreMenuViewController.h"
#import "CategoryListController.h"
#import "RestaurantMapTableViewCell.h"
#import <MapKit/MapKit.h>
#import <SafariServices/SafariServices.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import "NSDate+TimeAgo.h"

@import CoreLocation;

typedef NS_ENUM(NSInteger, RestaurantType) {
    RestaurantPhoto,
    RestaurantNoPhoto,
    RestaurantPhotoDetails,
    RestaurantHeader,
    RestaurantHeaderDetailsAddress,
    RestaurantHeaderDetailsPhone,
    RestaurantHeaderDetailsWebSite,
    RestaurantHeaderDetailsTime,
    RestaurantHeaderDetailsSave,
    RestaurantMap,
    RestaurantGallery,
    RestaurantBackToTop,
    RestaurantBanner
};

@interface RestaurantViewController () <RestaurantDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>{
    BOOL showingPhotoDetails;
    BOOL showingOpeningTime;
    NSMutableArray *sections;
    int currentDish;
    BOOL showPlaceholderOnImageLoad;
    BOOL didCountVisit;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end


MKMapRect MapRectBoundingMapPoints(MKMapPoint points[], NSUInteger pointCount){
    double minX = INFINITY, maxX = -INFINITY, minY = INFINITY, maxY = -INFINITY;
    NSInteger i;
    for (i = 0; i < pointCount; i++) {
        MKMapPoint p = points[i];
        minX = MIN(p.x, minX);
        minY = MIN(p.y, minY);
        maxX = MAX(p.x, maxX);
        maxY = MAX(p.y, maxY);
    }
    return MKMapRectMake(minX, minY, maxX - minX,  maxY - minY);
    
}

@implementation RestaurantViewController

- (NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    NSLog(@"===date%@",convertedDate);
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"";
    } else  if (ti < 60) {
        int diff=round(ti);
        return [NSString stringWithFormat:@"%d seconds ago", diff];
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else if (ti < 31536000) {
        int diff = round(ti / 60 / 60 / 24 / 30);
        return[NSString stringWithFormat:@"%d months ago", diff];
    } else {
        int diff = round(ti / 60 / 60 / 24 / 30/ 12 );
        return[NSString stringWithFormat:@"%d days ago", diff];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    showPlaceholderOnImageLoad = true;
    
    sections = [[NSMutableArray alloc] init];
    self.restaurantDishes = [[NSMutableArray alloc] init];
    
    [self getUsersCurrentLocation];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    [self.tableView reloadData];
    [self syncronize];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //makes sure the tutorial will only be shown once.
    if(![APIManager sharedInstance].didShowTutorialForRestaurant){
        [APIManager sharedInstance].didShowTutorialForRestaurant = true;
        [[APIManager sharedInstance] saveDefaults];
        [self performSegueWithIdentifier:@"feedTutorialSegue" sender:self];
    }
}

-(void)getUsersCurrentLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
}

- (void)syncronize{
    if(self.dish){
        //restaurant
        self.restaurant = [Restaurant restaurantWithId:self.dish.restaurantId];
        [self prepareSnapshot];
        [self dishesForRestaurant];
        [self updateSections];
        //[self generateMapImage];
        
        
        showPlaceholderOnImageLoad = false;
        
        if (!self.restaurant) {
            [self.view startLoading]; // Only show spinner if there was no restaurant and we need to fetch all data.
        }
        
        // Always fetch data to get most updated averageRating
        [[APIManager sharedInstance] getRestaurantWithId:self.dish.restaurantId completion:^(BOOL success, APIResponse *response) {
            [self.view stopLoading];
            
            self.restaurant = [Restaurant restaurantWithId:self.dish.restaurantId];
            [self dishesForRestaurant];
            [self updateSections];
            NSLog(@"RESTARUANT AVERAGE RATING: %1.2f", [self.restaurant.averageRating doubleValue]);
            
            //[self generateMapImage];
            
        }];
    }else{
        
        [self dishesForRestaurant];
        [self updateSections];
        showPlaceholderOnImageLoad = false;
        
        [[APIManager sharedInstance] getRestaurantWithId:self.restaurant.restaurantId completion:^(BOOL success, APIResponse *response) {
            [self.view stopLoading];
            
            self.restaurant = [Restaurant restaurantWithId:self.restaurant.restaurantId];
            [self dishesForRestaurant];
            [self updateSections];
            NSLog(@"RESTARUANT AVERAGE RATING: %1.2f", [self.restaurant.averageRating doubleValue]);
            
            //[self generateMapImage];
            
        }];
//        [self.tableView reloadData];
    }
}


- (void)generateMapImage
{

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.restaurant.latitude doubleValue] longitude:[self.restaurant.longitude doubleValue]];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
        
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = region;
        options.scale = [UIScreen mainScreen].scale;
        options.size = CGSizeMake(self.view.bounds.size.width, 185);
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        
        dispatch_queue_t executeOnBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        [snapshotter startWithQueue:executeOnBackground completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            
            UIImage *image = snapshot.image;
            snapshot = nil;
            
            MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:@""];
            UIImage *pinImage = pin.image;
            
            UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
            [image drawAtPoint:CGPointMake(0, 0)];
            
            CGPoint point = [snapshot pointForCoordinate:location.coordinate];
            
            CGPoint pinCenterOffset = pin.centerOffset;
            point.x -= pin.bounds.size.width / 2.0;
            point.y -= pin.bounds.size.height / 2.0;
            //point.x += pinCenterOffset.x;
            //point.y += pinCenterOffset.y;
            
            [pinImage drawAtPoint:point];
            
            __block UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            image = nil;
            
            _mapImage = finalImage;
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (!error) {
//                    
//                    _mapImage = [UIImageView new];
//                    _mapImage.image = finalImage;
//                    
//                }
//            });
        }];
        
    });
}


-(MKMapSnapshotOptions *)snapshotOptionsWithRegion:(MKCoordinateRegion)coordinateRegion
{
    //create the optionn for the snapshotter
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc]init];
    //we passed the region previously created
    options.region = coordinateRegion;
    options.scale = [[UIScreen mainScreen] scale]; // get the scale depending on the device resolution
    options.size = CGSizeMake(self.view.bounds.size.width, 185);//this is the image view that is going to display the snapshot
    //you can also define a camera for the options, to rotate heading pitch and other variables, but we won't do this here.
    
    return options;
}

-(void)createSnapshotWithOptions:(MKMapSnapshotOptions *)options fristCoords:(CLLocationCoordinate2D)firstCoords
{
    
    dispatch_queue_t executeOnBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
        
    //create the snapshotter
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc]initWithOptions:options];
    [snapshotter startWithQueue:executeOnBackground completionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (error) {
            NSLog(@"error %@",error);
            return ;
        }
        
        UIImage *image = snapshot.image;
        
        //create a pin to get the pin image
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:@""];
        pin.pinColor = MKPinAnnotationColorPurple;
        UIImage *firstPointPinImage = pin.image;

        
        CGPoint firstPoint = [snapshot pointForCoordinate:firstCoords];
        
        //move the pin so that the "base" of the pin points to the right spot
        CGPoint pinCenterOffset = pin.centerOffset;
        firstPoint.x -= pin.bounds.size.width / 2.0;
        firstPoint.y -= pin.bounds.size.height / 2.0;
        firstPoint.x += pinCenterOffset.x;
        firstPoint.y += pinCenterOffset.y;
        

        UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
        
        //draw the pins on the image
        [image drawAtPoint:CGPointMake(0, 0)];
        [firstPointPinImage drawAtPoint:firstPoint];
        
        //get the final image with the pins on top
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _mapImage = finalImage;
            [self updateSections];
        });
        
        
        
    }];
    
}
-(void)prepareSnapshot
{
    
    //get the coordinates to show
    //CLLocationCoordinate2D firstPoint = CLLocationCoordinate2DMake(37.425105, -122.126424);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.restaurant.latitude doubleValue] longitude:[self.restaurant.longitude doubleValue]];
    CLLocationCoordinate2D firstPoint = location.coordinate;
    
    MKMapPoint points[] = {
        MKMapPointForCoordinate(firstPoint),
    };
    
    //create the region with the helper method previously declared
    MKMapRect rect = MapRectBoundingMapPoints(points, 1);
    
    //create the region with padding
    rect = MKMapRectInset(rect,
                          -rect.size.width * 0.05,
                          -rect.size.height * 0.05);
    MKCoordinateRegion coordinateRegion = MKCoordinateRegionForMapRect(rect);
    
    //create the options for the snapshotter
    //a snapshot requires some options to be defined, more on that on the next method
    MKMapSnapshotOptions *options = [self snapshotOptionsWithRegion:coordinateRegion];
    
    //create snapshotter and execute the snapshot
    [self createSnapshotWithOptions:options
                        fristCoords:firstPoint];
    
    
}

-(void)dishesForRestaurant{
    if(!self.restaurant)
        return;
    
    [self.restaurantDishes removeAllObjects];
    [self.restaurantDishes addObjectsFromArray:[Dish dishesWithRestaurantId:self.restaurant.restaurantId]];
    
    if(self.restaurantDishes.count > 0){
        //in case it comes from saved restaurant, add the default dish
        if(!self.dish)
            self.dish = [self.restaurantDishes objectAtIndex:0];
        else if([self.restaurantDishes containsObject:self.dish]){
            //if there is already a default dish, makes sure it doesn't duplicate in the array
            [self.restaurantDishes removeObject:self.dish];
            [self.restaurantDishes insertObject:self.dish atIndex:0];
        }
    }else{
        if(self.dish)
            [self.restaurantDishes addObject:self.dish];
    }
    
    Search *search = [[Search alloc] init];
    search.restaurantId = self.restaurant.restaurantId;
    [self.view startLoading];
    [[APIManager sharedInstance] searchDishesWithSearch:search completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        [self.restaurantDishes removeAllObjects];
        [self.restaurantDishes addObjectsFromArray:response.results];
        
        if(self.restaurantDishes.count > 0){
            //in case it comes from saved restaurant, add the default dish
            if(!self.dish)
                self.dish = [self.restaurantDishes objectAtIndex:0];
            else if([self.restaurantDishes containsObject:self.dish]){
                //if there is already a default dish, makes sure it doesn't duplicate in the array
                [self.restaurantDishes removeObject:self.dish];
                [self.restaurantDishes insertObject:self.dish atIndex:0];
            }
        }
        
        [self updateSections];
    }];
}

-(void)showRestaurantViewCountAlert{
    if(!self.restaurant || [self.restaurant.saved boolValue])
        return;
    
    //show popup to save restaurant according to view count
    if([self.restaurant.visitCounts intValue] == 10)
        if(![self.restaurant.didShowViewCountPopup boolValue]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"views_over10x", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"views_nothanks", @"") otherButtonTitles:NSLocalizedString(@"views_save", @""), nil];
            [alertView show];
            
            self.restaurant.didShowViewCountPopup = [NSNumber numberWithBool:true];
            [CDHelper save];
        }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[ProfileOtherViewController class]]){
        ((ProfileOtherViewController*)segue.destinationViewController).user = self.dish.user;
    }else if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationController = segue.destinationViewController;
        if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[GalleryPhotoViewController class]]){
            if([sender isKindOfClass:[Dish class]])
                ((GalleryPhotoViewController*)[navigationController.viewControllers objectAtIndex:0]).dish = sender;
        }
    }else if([segue.destinationViewController isKindOfClass:[MoreMenuViewController class]]){
        Dish *dish = self.dish;
        if(self.restaurantDishes.count > currentDish)
            dish = [self.restaurantDishes objectAtIndex:currentDish];
        
        ((MoreMenuViewController*)segue.destinationViewController).dish = dish;
        ((MoreMenuViewController*)segue.destinationViewController).restaurant = self.restaurant;
    }
    
    else if([segue.destinationViewController isKindOfClass:[CategoryListController class]]){
        ((CategoryListController*)segue.destinationViewController).restaurant = self.restaurant;
    }
}

-(IBAction)unwindToRestaurant:(UIStoryboardSegue*)sender{
    
}

#pragma mark - Events

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)filterButtonPressed:(id)sender {
}

- (IBAction)menuButtonPressed:(id)sender {
    
}

#pragma mark - Table view data source

-(void)updateSections{
    [sections removeAllObjects];
    
    //NSLog(@"Restaurant ===> %@: Name ===> %@", self.restaurant.marketingBanner, self.restaurant.name);
    
    NSMutableArray *section0 = [[NSMutableArray alloc] init];
    if (self.restaurant.marketingBanner) {
        [section0 addObject:[NSNumber numberWithInteger:RestaurantBanner]];
    }
    [sections addObject:section0];
    
    
    BOOL noDishesToShow = self.restaurantDishes.count == 0 && !self.dish;
    
    NSMutableArray *section1 = [[NSMutableArray alloc] init];
    if(!noDishesToShow){
        [section1 addObject:[NSNumber numberWithInteger:RestaurantPhoto]];
        [section1 addObject:[NSNumber numberWithInteger:RestaurantPhotoDetails]];
        self.navigationItem.rightBarButtonItem = self.menuButton;
    }else{
        [section1 addObject:[NSNumber numberWithInteger:RestaurantNoPhoto]];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [sections addObject:section1];
    
    NSMutableArray *section2 = [[NSMutableArray alloc] init];
    if(self.restaurant){
        //[section2 addObject:[NSNumber numberWithInteger:RestaurantHeader]];
        
        if(self.restaurant.address && self.restaurant.address.length > 0)
            [section2 addObject:[NSNumber numberWithInteger:RestaurantHeaderDetailsAddress]];
        if(self.restaurant.phone && self.restaurant.phone > 0)
            [section2 addObject:[NSNumber numberWithInteger:RestaurantHeaderDetailsPhone]];
        if(self.restaurant.menu && self.restaurant.menu > 0)
            [section2 addObject:[NSNumber numberWithInteger:RestaurantHeaderDetailsWebSite]];
        if(self.restaurant.openingTimes.count > 0)
            [section2 addObject:[NSNumber numberWithInteger:RestaurantHeaderDetailsTime]];
        if(![self.restaurant.saved boolValue])
            [section2 addObject:[NSNumber numberWithInteger:RestaurantHeaderDetailsSave]];
        [section2 addObject:[NSNumber numberWithInteger:RestaurantMap]];
        if(self.restaurantDishes.count > 0)
            [section2 addObject:[NSNumber numberWithInteger:RestaurantGallery]];
        if(!noDishesToShow)
            [section2 addObject:[NSNumber numberWithInteger:RestaurantBackToTop]];
    }
    //if(section1.count > 0)
        [sections addObject:section2];
    
    [self.tableView reloadData];
}

- (RestaurantType)rowTypeWithIndexPath:(NSIndexPath*)indexPath{
    return [[[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self rowTypeWithIndexPath:indexPath] == RestaurantBanner){
        BannerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"banner" forIndexPath:indexPath];
        [cell.bannerImg sd_setImageWithURL:[NSURL URLWithString:self.restaurant.marketingBanner] placeholderImage:nil];
        
        return cell;
    } else if([self rowTypeWithIndexPath:indexPath] == RestaurantPhoto){
        RestaurantPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
        cell.moreView.hidden = showingPhotoDetails;
        cell.delegate = self;
        [cell configWithDishes:self.restaurantDishes atPosition:currentDish showPlaceholder:true selectedImage:self.selectedImage];
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantNoPhoto){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nophoto" forIndexPath:indexPath];
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantPhotoDetails){
        RestaurantPhotoDetailsTableViewCell *cell;
        
        if(self.dish.comments.count > 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"photoDetails" forIndexPath:indexPath];
            Comment *comment = [[self.dish.comments allObjects] objectAtIndex:0];
            cell.descLabel.text = comment.comment;
        }else
            cell = [tableView dequeueReusableCellWithIdentifier:@"photoDetailsNoComments" forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.profileName.text = self.dish.user.userName;
        
        //NSString *date = [self.dish.createdAt substringWithRange:[NSMakeRange(0, 19)]];
        NSString *date = [self.dish.createdAt substringToIndex:19];
        cell.timeAgoLabel.text = [self dateDiff:date];
        
        //profile picture
        if(showingPhotoDetails)
            [cell setImageWithUrl:self.dish.user.userImage placeHolder:PJ_IMAGE_PLACEHOLDER showLoading:true imageViewName:@"profileImageView" tableView:tableView indexPath:indexPath completion:nil];
        
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeader){
        static NSString *HeaderCellIdentifier = @"header";
        RestaurantHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier forIndexPath:indexPath];
        
        cell.nameLabel.text = self.restaurant.name;
        cell.viewsCountLabel.text = [NSString stringWithFormat:@"%d", ([self.restaurant.visitCounts intValue]+1)];
        
        cell.delegate = self;
        
        cell.descLabel.text = @"";
        NSArray *categories = [CDHelper sortArray:[self.restaurant.categories allObjects] by:@"order" ascending:YES];
        for(Category *category in categories){
            if(cell.descLabel.text.length > 0)
                cell.descLabel.text = [cell.descLabel.text stringByAppendingString:@" · "];
            cell.descLabel.text = [cell.descLabel.text stringByAppendingString:category.name];
        }
        
        //count visit if not yet updated
        if(!didCountVisit){
            didCountVisit = true;
            [[APIManager sharedInstance] getDishWithId:self.dish.dishId completion:^(BOOL success, Dish *response) {
                didCountVisit = success;
                
                self.restaurant.visitCounts = [NSNumber numberWithInteger:[self.restaurant.visitCounts intValue]+1];
                [CDHelper save];
                cell.viewsCountLabel.text = [NSString stringWithFormat:@"%d", [self.restaurant.visitCounts intValue]+1];
                
                [self showRestaurantViewCountAlert];
            }];
        }
        
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsAddress){
        RestaurantHeaderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerDetailsFirst" forIndexPath:indexPath];
        cell.titleLabel.text = self.restaurant.address;
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsPhone){
        RestaurantHeaderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerDetails" forIndexPath:indexPath];
        cell.titleLabel.text = self.restaurant.phone;
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsWebSite){
        RestaurantHeaderDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerDetails" forIndexPath:indexPath];
        cell.titleLabel.text = NSLocalizedString(@"view_menu", @"");
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsTime){
        RestaurantHeaderDetailsTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time" forIndexPath:indexPath];
        
        cell.timeLabel.text = @"";
        NSArray *openingTimes = [CDHelper sortArray:[self.restaurant.openingTimes allObjects] by:@"order" ascending:YES];
        for(OpeningTime *openingTime in openingTimes){
            if(cell.timeLabel.text.length > 0)
                cell.timeLabel.text = [cell.timeLabel.text stringByAppendingString:@"\n"];
            cell.timeLabel.text = [cell.timeLabel.text stringByAppendingString:openingTime.formatted];
        }
        
        if(showingOpeningTime)
            [cell animateIn];
        
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsSave){
        RestaurantHeaderDetailsSaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"save" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantGallery){
        RestaurantGalleryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gallery" forIndexPath:indexPath];
        cell.delegate = self;
        [cell configWithDishes:self.restaurantDishes];
        return cell;
    }else if([self rowTypeWithIndexPath:indexPath] == RestaurantBackToTop){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"backToTop" forIndexPath:indexPath];
        return cell;
    } else if ([self rowTypeWithIndexPath:indexPath] == RestaurantMap) {
        RestaurantMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"map" forIndexPath:indexPath];
        //_mapImage.frame = cell.bounds;
        //cell.mapImage.image = _mapImage;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.restaurant.latitude doubleValue] longitude:[self.restaurant.longitude doubleValue]];
        
        [cell.mapImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=18&size=640x380&maptype=roadmap&markers=%f,%f&key=AIzaSyA7ZlUrkLmMMQKV8kCJsyWAWs3g0dvOpgE", [self.restaurant.latitude doubleValue], [self.restaurant.longitude doubleValue], [self.restaurant.latitude doubleValue], [self.restaurant.longitude doubleValue], nil]]];
        cell.mapImage.contentMode = UIViewContentModeScaleAspectFill;
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self rowTypeWithIndexPath:indexPath] == RestaurantNoPhoto){
        
    }if([self rowTypeWithIndexPath:indexPath] == RestaurantPhotoDetails){
        if([self.dish.user.userId isEqualToString:[APIManager sharedInstance].user.userId])
            [self performSegueWithIdentifier:@"profileOwnSegue" sender:self];
        else
            [self performSegueWithIdentifier:@"profileSegue" sender:self];
    } else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsAddress || [self rowTypeWithIndexPath:indexPath] == RestaurantMap) {
        NSString *addressOnMap = self.restaurant.address;
        NSString* addr = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@",addressOnMap];
        NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    } else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsPhone){
        NSString *cleanedString = [[self.restaurant.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
        NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
        [[UIApplication sharedApplication] openURL:phoneURL];
    } else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsWebSite){
        NSURL *url = [NSURL URLWithString:self.restaurant.menu];
        if ([SFSafariViewController class] != nil) {
            SFSafariViewController *safariController = [[SFSafariViewController alloc]initWithURL:url];
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:safariController];
            [navigationController setNavigationBarHidden:YES animated:NO];
            [self presentViewController:navigationController animated:YES completion:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
        
        
    } else if([self rowTypeWithIndexPath:indexPath] == RestaurantHeaderDetailsTime){
        RestaurantHeaderDetailsTimeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        showingOpeningTime = !showingOpeningTime;
        if(showingOpeningTime){
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [cell animateOutWithCompletion:^{
            }];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else if([self rowTypeWithIndexPath:indexPath] == RestaurantBackToTop){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ((NSInteger)[self rowTypeWithIndexPath:indexPath]) {
        case RestaurantBanner:
            return 60;
        case RestaurantPhoto:
            return [[UIScreen mainScreen] bounds].size.width;
        case RestaurantNoPhoto:
            return 150;
        case RestaurantHeader:
            return 145;
        case RestaurantPhotoDetails:
            return showingPhotoDetails ? 97 : 0;
        case RestaurantHeaderDetailsAddress:
            return 51;
        case RestaurantHeaderDetailsPhone:
            return 28;
        case RestaurantHeaderDetailsWebSite:
            return 28;
        case RestaurantHeaderDetailsTime:
            return showingOpeningTime ? 66 : 27;
        case RestaurantHeaderDetailsSave:
            return 59;
        case RestaurantGallery:
            return [[UIScreen mainScreen] bounds].size.width/singleGalleryItems-(singleGallerySpacing*(singleGalleryItems-1));
        case RestaurantBackToTop:
            return 58;
        case RestaurantMap:
            return 185;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ((NSInteger)[self rowTypeWithIndexPath:indexPath]) {
        case RestaurantBanner:
            return self.restaurant.marketingBanner ? 60 : 0;
        case RestaurantPhoto:
            return [[UIScreen mainScreen] bounds].size.width;
        case RestaurantNoPhoto:
            return UITableViewAutomaticDimension;
        case RestaurantHeader:
            return UITableViewAutomaticDimension;
        case RestaurantPhotoDetails:
            return showingPhotoDetails ? UITableViewAutomaticDimension : 0;
        case RestaurantHeaderDetailsAddress:
            return UITableViewAutomaticDimension;
        case RestaurantHeaderDetailsPhone:
            return UITableViewAutomaticDimension;
        case RestaurantHeaderDetailsWebSite:
            return UITableViewAutomaticDimension;
        case RestaurantHeaderDetailsTime:
            return showingOpeningTime ? UITableViewAutomaticDimension : 36;
        case RestaurantHeaderDetailsSave:
            return 59;
        case RestaurantGallery:
            return [[UIScreen mainScreen] bounds].size.width/singleGalleryItems-(singleGallerySpacing*(singleGalleryItems-1));
        case RestaurantBackToTop:
            return 58;
        case RestaurantMap:
            return 185;
        default:
            return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return nil;
    if(section == 1)
        return nil;
    if(section == 2){
        if([[sections objectAtIndex:1] count] == 0)
            return nil;
        
        static NSString *HeaderCellIdentifier = @"header";
        RestaurantHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
        if (cell == nil)
            cell = [[RestaurantHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HeaderCellIdentifier];
        
        cell.nameLabel.text = self.restaurant.name;
        cell.viewsCountLabel.text = [NSString stringWithFormat:@"%d", [self.restaurant.visitCounts intValue]+1];
        cell.ratingView.rating = [self.restaurant.averageRating doubleValue];
        cell.delegate = self;
        
        if (self.currentLocation) {
            // Calculate distance between current location and restaurant
            CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:[self.restaurant.latitude doubleValue] longitude:[self.restaurant.longitude doubleValue]];
            CLLocationDistance distance = [restaurantLocation distanceFromLocation:self.currentLocation];
            double distanceInMiles = distance / 1609.34; // Convert distance in meters to miles
            cell.distanceLabel.text = [NSString stringWithFormat:@"%1.1f miles", distanceInMiles];
            NSLog(@"Restaurant lat: %1.3f. Rest long: %1.3f. Current lat: %1.3f. Current long: %1.3f. Distance: %1.3f. Miles: %1.3f", [self.restaurant.latitude doubleValue], [self.restaurant.longitude doubleValue], self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude, distance, distanceInMiles);
        } else {
            // If currentLocation is nill, that means the location manager hasn't found location yet
            cell.distanceLabel.text = @"";
        }
        
        cell.descLabel.text = @"";
        NSArray *categories = [CDHelper sortArray:[self.restaurant.categories allObjects] by:@"order" ascending:YES];
        for(Category *category in categories){
            if(cell.descLabel.text.length > 0)
                cell.descLabel.text = [cell.descLabel.text stringByAppendingString:@" · "];
            cell.descLabel.text = [cell.descLabel.text stringByAppendingString:category.name];
        }
        
        //count visit if not yet updated
        if(!didCountVisit){
            didCountVisit = true;
            
            [[APIManager sharedInstance] getDishWithId:self.dish.dishId completion:^(BOOL success, Dish *response) {
                didCountVisit = success;
                
                self.restaurant.visitCounts = [NSNumber numberWithInteger:[self.restaurant.visitCounts intValue]+1];
                [CDHelper save];
                
                cell.viewsCountLabel.text = [NSString stringWithFormat:@"%d", [self.restaurant.visitCounts intValue]+1];
                
                [self showRestaurantViewCountAlert];
            }];
        }
        
        cell.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, cell.frame.size.height);
        UIView * view = [[UIView alloc] initWithFrame:cell.frame];
        [view addSubview:cell];
                
        return view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0;
    if(section == 1)
        return 0;
    if(section == 2){
        if([[sections objectAtIndex:1] count] == 0)
            return 0;
        return 135;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 0;
    if(section == 1)
        return 0;
    if(section == 2){
        if([[sections objectAtIndex:1] count] == 0)
            return 0;
        return UITableViewAutomaticDimension;
    }
    return 0;
}

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self saveRestaurant];
    }
}

#pragma mark -  Feed Delegate

-(void)showPhotoDetails:(BOOL)show{
    showingPhotoDetails = show;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    if(!showingPhotoDetails){
        RestaurantPhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        cell.moreView.hidden = NO;
    }
}

-(void)didSelectDishFromGallery:(Dish *)dish{
    [self performSegueWithIdentifier:@"galleryPhotoSegue" sender:dish];
}

-(void)didChangeDish:(int)position{
    currentDish = position;
    self.dish = [self.restaurantDishes objectAtIndex:currentDish];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)likeDish:(BOOL)like{
    
}

-(void)saveRestaurant{
    if([self.restaurant.saved boolValue])
        return;
    
    self.restaurant.saved = [NSNumber numberWithBool:YES];
    [CDHelper save];
    
    //remove save button after saving
//    NSIndexPath *indexPath;
//    for(int section = 0; section < sections.count; section++){
//        NSArray *sectionArray = [sections objectAtIndex:section];
//        for(int row = 0; row < sectionArray.count; row++){
//            if([[sectionArray objectAtIndex:row] intValue] == RestaurantHeaderDetailsSave){
//                indexPath = [NSIndexPath indexPathForRow:row inSection:section];
//                break;
//            }
//        }
//    }
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self updateSections];
}

-(void)toggleOpeningHours{
    showingOpeningTime = !showingOpeningTime;
    
    for(int i = 0; i < [[sections objectAtIndex:1] count]; i++){
        if([[[sections objectAtIndex:1] objectAtIndex:i] integerValue] == RestaurantHeaderDetailsTime)
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:2]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)didTapRestaurantViewsCount{
    [self performSegueWithIdentifier:@"showCategories" sender:nil];
}

#pragma CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    NSLog(@"Did update location...");
    if (fabs(howRecent) < 15.0) {
        NSLog(@"Location is recent enough, updating distance from current location.");
        [self.locationManager stopUpdatingLocation];
        self.currentLocation = location;
        [self updateSections];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if( error == kCLErrorLocationUnknown ) {
        NSLog(@"location services error: %@", error);
    }
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"error getting location: %@", [error localizedDescription]);
}

@end
