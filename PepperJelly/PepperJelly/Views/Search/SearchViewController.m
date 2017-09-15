//
//  SearchViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/17/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "SearchViewController.h"
#import "DesignableTextField.h"
#import "UIColor+PepperJelly.h"
#import "SearchProtocols.h"
#import "ProfileViewController.h"
#import "ProfileOtherViewController.h"
#import "RestaurantViewController.h"
#import "APIManager.h"
#import "UIView+Loading.h"
#import "AlgoliaSearch-Swift.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProfileProtocols.h"
#import "ProfileSavedTableViewCell.h"
#import "Restaurant.h"
#import "User.h"
#import "CDHelper.h"
#import "UserData.h"
#import "ProfileFollowsTableViewCell.h"
#import "UITableViewCell+Online.h"
#import "UIImage+Online.h"
#import "RestaurantData.h"

typedef enum{
    SearchRestaurant,
    SearchUser
}SearchType;

@interface SearchViewController () <UITextFieldDelegate, SearchDelegate, UITableViewDelegate, UITableViewDataSource, ProfileDelegate>{
    SearchType selectedSearchType;
    BOOL animating;
}

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet DesignableTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UIButton *clearSearchButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *users;
//@property (strong, nonatomic) NSMutableArray *followerUsers;
@property (strong, nonatomic) NSMutableArray *followingUsers;
@property (strong, nonatomic) NSMutableArray *filteredUsers;
@property (strong, nonatomic) NSMutableArray *savedRestaurants;
@property (strong, nonatomic) NSArray *restaurants;
@property (strong, nonatomic) NSMutableArray *filteredRestaurants;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) Client *searchClient;

@property (strong, nonatomic) NSMutableArray *resultsRestaurants;
@property (strong, nonatomic) NSMutableArray *resultsUsers;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = true;
    
    //disables so we can enable it in the child scrollviews
    
    self.filteredUsers = [[NSMutableArray alloc] init];
    self.filteredRestaurants = [[NSMutableArray alloc] init];
    
    [self.searchTextField becomeFirstResponder];
    
    _searchClient = [[Client alloc] initWithAppID:@"48EUWY9NWN" apiKey:@"1dce9ee52d4baaf5e64d24e3892cca87"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self syncronize];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_searchTextField becomeFirstResponder];
}

-(void)syncronize{
    //self.followerUsers = [[NSMutableArray alloc] initWithArray:[CDHelper sortArray:[[APIManager sharedInstance].user.followerUsers allObjects] by:@"fullName" ascending:YES]];
    self.followingUsers = [[NSMutableArray alloc] initWithArray:[CDHelper sortArray:[[APIManager sharedInstance].user.followingUsers allObjects] by:@"fullName" ascending:YES]];
    
    //Followers and following
    [self.view startLoading];
//    [[APIManager sharedInstance] getFollowersWithUser:[APIManager sharedInstance].user completion:^(BOOL success, APIResponse *response) {
//        
//        [self.followerUsers removeAllObjects];
//        [self.followerUsers addObjectsFromArray:[CDHelper sortArray:[[APIManager sharedInstance].user.followerUsers allObjects] by:@"fullName" ascending:YES]];
//        [self clearFilteredUsers];
    
        [[APIManager sharedInstance] getFollowingWithUser:[APIManager sharedInstance].user completion:^(BOOL success, APIResponse *response) {
            [self.view stopLoading];
            
            [self.followingUsers removeAllObjects];
            [self.followingUsers addObjectsFromArray:[CDHelper sortArray:[[APIManager sharedInstance].user.followingUsers allObjects] by:@"fullName" ascending:YES]];
            [self clearFilteredUsers];
        }];
//    }];
    [self clearFilteredUsers];
    
    self.savedRestaurants = [[NSMutableArray alloc] initWithArray:[Restaurant getSaved]];
    [self clearFilteredRestaurants];
}

-(void)clearFilteredUsers{
    [self.filteredUsers removeAllObjects];
//    [self.filteredUsers addObjectsFromArray:self.followerUsers];
    [self.filteredUsers addObjectsFromArray:self.followingUsers];
}

-(void)clearFilteredRestaurants{
    [self.filteredRestaurants removeAllObjects];
    [self.filteredRestaurants addObjectsFromArray:self.savedRestaurants];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[RestaurantViewController class]]){
        if([sender isKindOfClass:[Restaurant class]])
            ((RestaurantViewController*)segue.destinationViewController).restaurant = sender;
    }else if([segue.destinationViewController isKindOfClass:[ProfileOtherViewController class]]){
        if([sender isKindOfClass:[User class]])
            ((ProfileOtherViewController*)segue.destinationViewController).user = sender;
    }
}

#pragma mark - Events

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}



- (IBAction)clearSearchButtonPressed:(id)sender {
    self.searchTextField.text = @"";
    [self searchDataWithString:@""];
}

- (void)updateSearchType:(SearchType)type shouldScroll:(BOOL)shouldScroll{
    return;
    
    if(animating)
        return;
    animating = true;
    
    selectedSearchType = type;
    

    switch (selectedSearchType) {
        case SearchRestaurant:
        {
            [UIView animateWithDuration:0.2f animations:^{

            }completion:^(BOOL finished) {
                animating = false;
            }];
        }
            break;
        case SearchUser:
        {
            [UIView animateWithDuration:0.2f animations:^{

            }completion:^(BOOL finished) {
                animating = false;
            }];
        }
            break;
    }
    
    [self searchDataWithString:self.searchTextField.text];
}

-(void)searchDataWithString:(NSString*)searchTerm{
    self.searchTerm = searchTerm;
    
    self.clearSearchButton.hidden = (self.searchTerm.length == 0);
    
    if(searchTerm.length == 0){
        self.users = nil;
        self.restaurants = nil;
        [self clearFilteredUsers];
        [self clearFilteredRestaurants];
        
        
        [_tableView reloadData];
        
        return;
    }
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    Index *searchIndex = [_searchClient indexWithName:@"pepperjelly"];
    Query *searchQuery = [[Query alloc] initWithQuery:searchTerm];
    searchQuery.facets = @[@"type"];
    searchQuery.filters = @"type:restaurant";
    searchQuery.hitsPerPage = @5;
    searchQuery.aroundLatLng = [[LatLng alloc] initWithLat:locationManager.location.coordinate.latitude lng:locationManager.location.coordinate.longitude];
   
    [searchIndex search:searchQuery completionHandler:^(NSDictionary * content, NSError * error) {
        
        NSLog(@"--------%@", content);
        
        NSMutableArray *restaurants = [[NSMutableArray alloc] init];
        if ([content[@"hits"] respondsToSelector:@selector(count)]) {
            
            
            for (NSDictionary *restaurantData in content[@"hits"]) {
                
                RestaurantData *tmpRestaurantData = [[RestaurantData alloc] init];
                
                [restaurantData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                    if ([RestaurantData instancesRespondToSelector:NSSelectorFromString(key)]) {
                        [tmpRestaurantData setValue:obj forKey:(NSString *)key];
                    }
                }];
                
                [restaurants addObject:[Restaurant restaurantWithRestaurantData:tmpRestaurantData]];
                //[CDHelper save];
            }
            
            
        }
        
        _restaurants = restaurants;
        
        
        
        
        Query *searchQuery2 = [[Query alloc] initWithQuery:searchTerm];
        searchQuery2.facets = @[@"type"];
        searchQuery2.filters = @"type:user";
        searchQuery2.hitsPerPage = @5;
    
        [searchIndex search:searchQuery2 completionHandler:^(NSDictionary * content, NSError * error) {
            
            NSMutableArray *users = [[NSMutableArray alloc] init];
            
            if ([content[@"hits"] respondsToSelector:@selector(count)]) {
                
                for (NSDictionary *userData in content[@"hits"]) {
                    
                    UserData *tmpUserData = [[UserData alloc] init];
                    
                    [userData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                        if ([UserData instancesRespondToSelector:NSSelectorFromString(key)]) {
                            [tmpUserData setValue:obj forKey:(NSString *)key];
                        }
                    }];
                    
                    [users addObject:[User userWithUserData: tmpUserData]];
                }
            }
            
            self.users = users;
            
            [_tableView reloadData];
        }];
    }];
    

}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.clearSearchButton.hidden = (self.searchTextField.text.length == 0);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.clearSearchButton.hidden = (self.searchTextField.text.length == 0);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *searchTerm = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self searchDataWithString:searchTerm];
    return true;
}



#pragma mark - Search Delegate

-(void)openUser:(id)user{
    [self.searchTextField resignFirstResponder];
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}

-(void)openRestaurant:(id)restaurant{
    [self.searchTextField resignFirstResponder];
    [self performSegueWithIdentifier:@"restaurantSegue" sender:restaurant];
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        if(self.restaurants.count == 0) return nil;
        return @"Restaurants";
    }
    else {
        if(self.users.count == 0) return nil;
        return @"People";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(section == 0) return self.restaurants.count;
    if(section == 1) return self.users.count;
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        ProfileSavedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"saved" forIndexPath:indexPath];
        
        cell.saved = [self.restaurants objectAtIndex:indexPath.row];
        
        Restaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];
        cell.nameLabel.text = restaurant.name;
        cell.addressLabel.text = restaurant.address;
        [cell.thumbImage sd_setImageWithURL:[NSURL URLWithString:restaurant.image]];
        
        return cell;
    }
    
    else {
        User *user = [self.users objectAtIndex:indexPath.row];
        
        BOOL following = [[APIManager sharedInstance].user.followingUsers containsObject:user];
        
        ProfileFollowsTableViewCell *cell;
        if(following)
            cell = [tableView dequeueReusableCellWithIdentifier:@"unfollow" forIndexPath:indexPath];
        else
            cell = [tableView dequeueReusableCellWithIdentifier:@"follow" forIndexPath:indexPath];
        
        [cell configWithUser:user following:following delegate:self];
        
        //makes sure user can't follow himself
        if([user.userId isEqualToString: [APIManager sharedInstance].user.userId]){
            cell.followButton.hidden = true;
            cell.titleLabel.translatesAutoresizingMaskIntoConstraints = true;
            cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.frame.size.width-cell.titleLabel.frame.origin.x, cell.titleLabel.frame.size.height);
        }
        
        //profile picture
        [cell setImageWithUrl:user.userImage placeHolder:PJ_IMAGE_PLACEHOLDER showLoading:true imageViewName:@"profileImageView" tableView:tableView indexPath:indexPath completion:nil];
        
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) [self openRestaurant:[self.restaurants objectAtIndex:indexPath.row]];
    else [self openUser:[self.users objectAtIndex:indexPath.row]];
    
}

#pragma mark - Profile Delegate

-(void)followUser:(User *)user{
    [[APIManager sharedInstance] followUserWithId:user.userId completion:^(BOOL success, APIResponse *response) {
        [self.tableView reloadData];
    }];
}

-(void)unfollowUser:(User *)user{
    [[APIManager sharedInstance] unfollowUserWithId:user.userId completion:^(BOOL success, APIResponse *response) {
        [self.tableView reloadData];
    }];
}


@end
