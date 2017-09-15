//
//  AddResaurantViewController.m
//  PepperJelly
//
//  Created by Sean McCue on 4/22/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "AddRestaurantViewController.h"
#import "FilterTableViewCell.h"
#import "APIManager.h"
#import "DesignableTextField.h"
#import "GooglePlace.h"

@interface AddRestaurantViewController ()<UITextViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet DesignableTextField *searchTextField;
@property (nonatomic, strong)NSMutableArray *restaraunts;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AddRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restaraunts = [NSMutableArray new];
    self.navigationItem.hidesBackButton = true;
    
    self.tableView.estimatedRowHeight = 21.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getUsersCurrentLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
-(void)unwindSegue{
    [self performSegueWithIdentifier:@"unwindToPublish" sender:nil];
}

#pragma mark - Events
- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.restaraunts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    GooglePlace *gp = [[GooglePlace alloc] init];
    gp = [self.restaraunts objectAtIndex:indexPath.row];
    cell.titleLabel.text = gp.placeDescription;
    return cell;
}

#pragma mark - TablveViewDelegate Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GooglePlace *gp = [[GooglePlace alloc] init];
    gp = [self.restaraunts objectAtIndex:indexPath.row];
    self.selectedRestaurant = gp;
    [self unwindSegue];
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
    
    [self searchGooglePlacesWithInput:searchTerm];
    
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextField resignFirstResponder];
    return true;
}

#pragma mark - API
-(void)searchGooglePlacesWithInput:(NSString *)input{
    [[APIManager sharedInstance] searchRestaurantWithInput:input latitude:
     [APIManager sharedInstance].currentLocation.coordinate.latitude longitude:[APIManager sharedInstance].currentLocation.coordinate.longitude radius:RESTAURANT_SEARCH_RADIUS completionHandler:^(BOOL success, APIResponse *response) {
        if(success){
            //NSLog(@"GOOGLE PLACES: %@", response.googlePlaces);
            self.restaraunts = response.googlePlaces;
            [self.tableView reloadData];
        }else{
            NSLog(@"error searching");
        }
    }];
}

#pragma MARK - CLLocationManagerDelegate

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

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* location = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [APIManager sharedInstance].currentLocation = location;
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
@end
