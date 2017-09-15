//
//  LocationsViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationTableViewCell.h"
#import "UIColor+PepperJelly.h"
#import "UISearchBar+Custom.h"
#import "DesignableTextField.h"
#import "SearchManager.h"
#import "APIManager.h"
#import "UIView+Loading.h"

@interface LocationsViewController () <UITextFieldDelegate, CLLocationManagerDelegate>{
    BOOL searching;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *recentLocations;
@property (nonatomic, strong) NSMutableArray *locations;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet DesignableTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cacelButton;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *currentAddress;

@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view startLoading];
    
    self.recentLocations = [[NSMutableArray alloc] init];
    self.locations = [[NSMutableArray alloc] init];
    
    self.navigationItem.hidesBackButton = true;
    self.titleView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.titleView.frame.size.height);
    
    [self getUsersCurrentLocation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - Events

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)getUsersCurrentLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(searching) {
        if(section == 0)
            return 0;
        else
            return self.locations.count;
    }
    
    if(section == 0)
        return 1;
    else
        return self.recentLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentLocation" forIndexPath:indexPath];
        return cell;
    }else{
        LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"location" forIndexPath:indexPath];
        
        NSString *location = @"";
        
        if(searching || !self.showRecentLocations){
            location = [self.locations objectAtIndex:indexPath.row];
        }
        else{
            location = [self.recentLocations objectAtIndex:indexPath.row];
        }
        
        cell.titleLabel.text = location;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 44;
    return 42;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0 || searching || !self.showRecentLocations){
        return [UIView new];
    }
    
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentLocations"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0 || searching)
        return 0;
    return 42;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchTextField resignFirstResponder];
}

-(void)searchForLocationWithSearchTerm:(NSString *)term{
    [[SearchManager searchManager] searchForMatch:term andCompletionHandler:^(NSMutableArray *resultsArray) {
        searching = true;
        self.locations = resultsArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - TextField Delegate


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        
        //hide keyboard and callback delegate
        [self.searchTextField resignFirstResponder];
        return NO;
    }
    
    NSString *searchTerm = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"new string: %@", searchTerm);
    
    [self searchForLocationWithSearchTerm:searchTerm];
    
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    searching = false;
    [self.tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextField resignFirstResponder];
    return true;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedLocation = [NSMutableDictionary new];
    [self.view startLoading];
    if(searching){
        [self.searchTextField resignFirstResponder];
        NSString *address = [self.locations objectAtIndex:indexPath.row];
        NSLog(@"location: %@", address);
        [self.searchTextField setText:address];
        [self.selectedLocation setObject:address forKey:@"address"];
        [[SearchManager searchManager] geocodeFromAddressString:address andCompletionHandler:^(CLLocation *location) {
            [self.selectedLocation setObject:location forKey:@"location"];
            [self.selectedLocation setObject:[NSNumber numberWithInt:1] forKey:@"useCustomLocation"];
            [self.view stopLoading];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self unwindSegue];
            });
        }];
    }else{
        if(self.currentAddress && self.currentLocation){
            [self.selectedLocation setObject:self.currentAddress forKey:@"address"];
            [self.selectedLocation setObject:[NSNumber numberWithInt:0] forKey:@"useCustomLocation"];
            [APIManager sharedInstance].currentLocation = self.currentLocation;
            [self.view stopLoading];
            [self.selectedLocation setObject:self.currentLocation forKey:@"location"];
            [self unwindSegue];
        }else{
            [self getUsersCurrentLocation];
            return;
        }
    }
}

-(void)unwindSegue{
    if(self.enteredFromSubmitReview){
        [self performSegueWithIdentifier:@"unwindToSignUpReview" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"unwindToFilter" sender:nil];
    }
}

#pragma CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (fabs(howRecent) < 15.0) {
        [self.locationManager stopUpdatingLocation];
        [self updateAddressLocation:location];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    [self.view stopLoading];
    
    if( error == kCLErrorLocationUnknown ) {
        NSLog(@"location services error: %@", error);
    }

    [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_location", @"") viewController:self];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"error getting location: %@", [error localizedDescription]);
}

- (void)updateAddressLocation:(CLLocation *)location {
    [[SearchManager searchManager] reverseGeocodeByLocation:location andCompletionHandler:^(NSString *address, NSError *error){
        if (error) {
            self.currentLocation = nil;
            self.currentAddress = nil;
        } else {
            self.currentLocation = location;
            self.currentAddress = address;
            NSLog(@"ADDRESS: %@", self.currentAddress);
        }
        
        [self.view stopLoading];
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
                [self.view stopLoading];
                break;
            }
                //the device has parental controls enabled
            case kCLAuthorizationStatusRestricted: {
                NSLog(@"location restricted");
                [self.view stopLoading];
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_location", @"") viewController:self];
                break;
            }
                
                //user explicitly denied location services
            case kCLAuthorizationStatusDenied: {
                [self.view stopLoading];
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
        [self.view stopLoading];
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_location_permissions", @"") viewController:self];
    }
    
}



@end
