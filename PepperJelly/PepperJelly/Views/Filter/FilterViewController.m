//
//  FilterViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PepperJelly-Swift.h" // Imports all swift files
#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "DesignableButton.h"
#import "Constants.h"
#import "LocationsViewController.h"
#import "APIManager.h"
#import "Category.h"
#import "UIView+Loading.h"
#import "User.h"
#import "UserCategory.h"
#import "SearchManager.h"
#import "Search.h"
#import "CategoryItem.h"
#import "FilterDetailsViewController.h"
#import <Mixpanel/Mixpanel.h>

@interface FilterViewController () // <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *distanceContainerView;
// @property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet DesignableButton *titleButton;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
//
//@property (nonatomic, strong) NSMutableArray *categories;
//@property (nonatomic, strong) NSMutableArray *selectedCategoriesArray;
@property (nonatomic, strong) Search *searchOptions;
@property (nonatomic, strong) NSNumber *useCustomLocation;
@property (nonatomic, strong) DropDown *distanceDropdown;
@property (nonatomic, strong) NSArray *distanceOptions;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //enable to scrolltotop when tap on statusbar
    // self.tableView.scrollsToTop = true;
    
//    self.categories = [[NSMutableArray alloc] init];
    [self resetButtonPressed:self];
    self.selectedLocation = [[CLLocation alloc] initWithLatitude:[[APIManager sharedInstance].user.locationLatitude doubleValue] longitude:[[APIManager sharedInstance].user.locationLongitude doubleValue]];
    
    /*
    self.selectedCategoriesArray = [[NSMutableArray alloc] init];
    for(UserCategory *category in [APIManager sharedInstance].user.categories)
        [self.selectedCategoriesArray addObject:category.name];
     */
    
    self.locationLabel.text = [APIManager sharedInstance].user.locationName;
    [self setUserLocation];
    
    self.searchOptions = [[Search alloc] init];
    
    [self setInitialDistanceValue:[[APIManager sharedInstance].user.locationRange intValue]];
    
    self.useCustomLocation = [APIManager sharedInstance].user.useCustomLocation;
    NSLog(@"Initial filter, use custom location: %d", [self.useCustomLocation intValue]);
    
    //open location controller
    if(self.changeLocationOnOpen){
        [self performSegueWithIdentifier:@"locationSegue" sender:self];
    }
    
    NSMutableArray *dropdownDatasource = [NSMutableArray array];
    for (int i = 1; i <= 10; i++) {
        if (i == 1) {
            [dropdownDatasource addObject:[NSString stringWithFormat:@"1 mile"]];
            continue;
        }
        [dropdownDatasource addObject:[NSString stringWithFormat:@"%d miles", i]];
        
    }
    self.distanceDropdown = [[DropDown alloc] init];
    self.distanceDropdown.anchorView = self.distanceLabel;
    self.distanceDropdown.dataSource = [dropdownDatasource copy];
    self.distanceDropdown.bottomOffset = CGPointMake(0, 30.0);
    [[DropDown appearance] setTextFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
    
    __block FilterViewController *weakSelf = self;
    [self.distanceDropdown setSelectionAction:^(NSInteger index, NSString * _Nonnull item) {
        NSLog(@"Selected index %ld", (long)index);
        [weakSelf setNewDistance:(int)index + 1]; // Add one to index value for the number of miles the user selected.
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [CDHelper save];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[FilterDetailsViewController class]]){
        /*
        FilterDetailsViewController *vc = (FilterDetailsViewController*)segue.destinationViewController;
        if([segue.identifier isEqualToString:@"viewAll"]){
            CategoryItem *categoryItem = [[CategoryItem alloc] initWithName:NSLocalizedString(@"Categories", @"")];
            
            for(CategoryItem *category in self.categories)
                [categoryItem.subcategoriesToShow addObjectsFromArray:category.subcategoriesToShow];
            [categoryItem.subcategories addObjectsFromArray:self.selectedCategoriesArray];
            
            vc.categoryItem = categoryItem;
        }else
            vc.categoryItem = [self.categories objectAtIndex:[self.tableView indexPathForSelectedRow].row];
         */
    }
}

-(IBAction)unwindToFilter:(UIStoryboardSegue *)segue{
    if([segue.sourceViewController isKindOfClass:[LocationsViewController class]]){
        LocationsViewController *vc = (LocationsViewController *)segue.sourceViewController;
        self.selectedAddress = [vc.selectedLocation objectForKey:@"address"];
        self.selectedLocation = [vc.selectedLocation objectForKey:@"location"];
        
        NSMutableDictionary *traitsDict = [NSMutableDictionary dictionary];
        traitsDict[@"Latitude"] = [NSNumber numberWithDouble:self.selectedLocation.coordinate.latitude];
        traitsDict[@"Longitude"] = [NSNumber numberWithDouble:self.selectedLocation.coordinate.longitude];
        [[Mixpanel sharedInstance].people set:[traitsDict copy]];
        
        NSLog(@"New location lat: %1.5f, long: %1.5f", self.selectedLocation.coordinate.latitude, self.selectedLocation.coordinate.longitude);
        self.useCustomLocation = [vc.selectedLocation objectForKey:@"useCustomLocation"];
    }else if([segue.sourceViewController isKindOfClass:[FilterDetailsViewController class]]){
        /*
        FilterDetailsViewController *vc = (FilterDetailsViewController*)segue.sourceViewController;
        
        //check if it's one of the service categories
        if([self.tableView indexPathForSelectedRow].row < self.categories.count){
            [self.categories replaceObjectAtIndex:[self.tableView indexPathForSelectedRow].row withObject:vc.categoryItem];
            
            [self.selectedCategoriesArray removeAllObjects];
            for(CategoryItem *categoryItem in self.categories)
                [self.selectedCategoriesArray addObjectsFromArray:categoryItem.subcategories];
            
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
         
        }else{
        
            // in case it's view all
            [self.selectedCategoriesArray removeAllObjects];
            [self.selectedCategoriesArray addObjectsFromArray:vc.categoryItem.subcategories];
            
            //refresh all others to get the correct selected categories
            [self getSavedList];
        }
        
        [self.tableView reloadData];
         */
    }
}

-(void)setSelectedAddress:(NSString *)selectedAddress{
    [self.locationLabel setText:selectedAddress];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = YES;
    [self.locationLabel sizeToFit];
}

#pragma mark - Events
/*
-(void)getSavedList{
    self.categories = [[NSMutableArray alloc] init];
    NSArray *results = [Category getAllTopLevel];
    if([results respondsToSelector:@selector(count)]){
        for (Category *category in results) {
            [self.categories addObject:[[CategoryItem alloc] initWithCategory:category selectedSubcategories:self.selectedCategoriesArray]];
        }
        if(self.categories.count > 0){
            [self.tableView reloadData];
        }
    }
}
*/

-(void)setUserLocation{
    [self.titleView startLoading];
    [[SearchManager searchManager] reverseGeocodeByLocation: self.selectedLocation andCompletionHandler:^(NSString *address, NSError *error) {
        [self.titleView stopLoading];
        if(!error){
            if (address.length > 0) {
                self.selectedAddress = address;
            } else {
                self.selectedAddress  = NSLocalizedString(@"default_location", @"");
            }
        }else{
            self.selectedAddress  = NSLocalizedString(@"default_location", @"");
        }
    }];
}

- (IBAction)resetButtonPressed:(id)sender {
    self.selectedLocation = [[CLLocation alloc] initWithLatitude:[[APIManager sharedInstance].user.locationLatitude doubleValue] longitude:[[APIManager sharedInstance].user.locationLongitude doubleValue]];
    [self setUserLocation];
    // self.selectedCategoriesArray = [[NSMutableArray alloc] init];
    self.distanceLabel.text = @"10 miles";
    [self setNewDistance:10];
    
    self.locationLabel.text = [APIManager sharedInstance].user.locationName;
    // [self.categories removeAllObjects];
    // [self getSavedList];
    // [self getCategoriesLIst];
}

- (IBAction)doneButtonPressed:(id)sender {
    [[Mixpanel sharedInstance] track:@"Searchedixpan"];
    UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
    [user setLatitude:self.selectedLocation.coordinate.latitude andLongitude:self.selectedLocation.coordinate.longitude];
    user.range = self.searchOptions.range;
    user.locationName = self.selectedAddress;
    user.useCustomLocation = [self.useCustomLocation boolValue];
    //user.useCustomLocation = [NSNumber numberWithBool:true];
    
    if([self.useCustomLocation boolValue]){
        NSLog(@"custom");
    }else{
        NSLog(@"current");
    }
    NSLog(@"range: %@", self.searchOptions.range);
    
    /*
    if(self.selectedCategoriesArray.count > 0)
        user.categories = self.selectedCategoriesArray;
    else
        user.categories = [[NSArray alloc] init];
    */
    
    [self.view startLoading];
    [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        if(success){
            [self.navigationController dismissViewControllerAnimated:true completion:nil];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_savefilter", @"") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"error_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewControllerAnimated:true completion:nil];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:true completion:nil];
        }
    }];
}

- (IBAction)changeDistancePressed:(UIButton *)sender {
    [self.distanceDropdown show];
}

- (void)setNewDistance:(int)value {
    NSLog(@"Value: %d", value);
    NSString *distanceString;
    if (value == 1) {
        distanceString = [NSString stringWithFormat:@"%d mile", value];
    } else {
        distanceString = [NSString stringWithFormat:@"%d miles", value];
    }
    self.distanceLabel.text = distanceString;
    self.searchOptions.range = [NSNumber numberWithInt:value * 1609]; // Save distance as meters
}

- (void)setInitialDistanceValue:(int)value {
    int miles = (int)round((double)value / 1609.0);
    if (miles > 10) {
        miles = 10;
    }
    NSString *distanceString;
    if (miles == 1) {
        distanceString = [NSString stringWithFormat:@"%d mile", miles];
    } else {
        distanceString = [NSString stringWithFormat:@"%d miles", miles];
    }
    self.distanceLabel.text = distanceString;
    self.searchOptions.range = [NSNumber numberWithInt:value]; // Value is already in meters
}

#pragma mark - TableView data source
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >= self.categories.count){
        FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"all" forIndexPath:indexPath];
        
        cell.subcategoriesLabel.text = @"";
        for(NSString *subcategory in self.selectedCategoriesArray){
            if(cell.subcategoriesLabel.text.length > 0)
                cell.subcategoriesLabel.text = [cell.subcategoriesLabel.text stringByAppendingString:@", "];
            cell.subcategoriesLabel.text = [cell.subcategoriesLabel.text stringByAppendingString:subcategory];
        }
        
        return cell;
    }
    
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filter" forIndexPath:indexPath];
    
    CategoryItem *categoryItem = [self.categories objectAtIndex:indexPath.row];
    cell.titleLabel.text = categoryItem.name;
    
    cell.subcategoriesLabel.text = @"";
    for(NSString *subcategory in categoryItem.subcategories){
        if(cell.subcategoriesLabel.text.length > 0)
            cell.subcategoriesLabel.text = [cell.subcategoriesLabel.text stringByAppendingString:@", "];
        cell.subcategoriesLabel.text = [cell.subcategoriesLabel.text stringByAppendingString:subcategory];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryHeader"];
        return cell;
    }
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
 */

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if(self.searching){
//        return  @"";
//    }else{
//        return [self.dataTitles objectAtIndex:section];
//    }
//}

#pragma  mark - API
/*
-(void)getCategoriesLIst{
    [[APIManager sharedInstance] getCategoryTreeListWithCompletion:^(BOOL success, NSArray* categories) {
        if(success){
            [self.categories removeAllObjects];
            for (Category *category in categories) {
                [self.categories addObject:[[CategoryItem alloc] initWithCategory:category selectedSubcategories:self.selectedCategoriesArray]];
            }
            [self.tableView reloadData];
        }else{
            if(![self.categories respondsToSelector:@selector(count)]){
                NSLog(@"failed to get categories list");
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_get_categories_list", @"") viewController:self];
            }
        }
    }];
}
 */

@end
