//
//  NewsFeedTableController.m
//  PepperJelly
//
//  Created by Sean McCue on 7/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "NewsFeedTableController.h"
#import "NewsFeed.h"
#import "NewsFeedCell.h"
#import "DesignableButton.h"
#import "UIView+Loading.h"
#import "APIManager.h"
#import "UIImageView+Online.h"
#import "UploadedPhotoViewController.h"
#import "ProfileOtherViewController.h"
#import "UIColor+PepperJelly.h"
#import "UIButton+Online.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsFeedTableController () <NewsFeedDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation NewsFeedTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIncomingActivePushNotifications:) name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    [self configureTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
    [self synchronize];
}

-(void)configureTableView{
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self initializeRefreshControl];
}

-(void)initializeRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(synchronize) forControlEvents:UIControlEventValueChanged];
}

-(void)synchronize{
    
    if(!self.dataArray){
        self.dataArray = [[NSMutableArray alloc] initWithArray:[NewsFeed getAll]];
        if(self.dataArray.count > 0)
            [self.tableView reloadData];
    }

    [self.view startLoading];
    [[APIManager sharedInstance] getNewsFeedWithCompletion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        if(success){
            NSLog(@"News Feed API results count: %lu", (unsigned long)response.results.count);
            NSLog(@"News Feed results.count: %lu", (unsigned long)self.dataArray.count);
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray: response.results];
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
        
        if([self.dataArray count] < 1){
            [self showNoRecentActivity];
        }
    }];
}

#pragma mark - Events

- (IBAction)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)showNoRecentActivity{
    UILabel *noRecentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 29)];
    UIFont *font = [UIFont fontWithName:@"Lato-Regular" size:24];
    noRecentLbl.font = font;
    noRecentLbl.textAlignment = NSTextAlignmentCenter;
    [noRecentLbl setTextColor:[UIColor greyishBrownColor]];
    noRecentLbl.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 3);
    noRecentLbl.text = @"No recent activity.";
    [self.view addSubview:noRecentLbl];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"News" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    NewsFeed *newsFeed = [self.dataArray objectAtIndex:indexPath.row];
    
    if([newsFeed.type isEqualToString:@"like"]){
        cell.followingButton.hidden = true;
        cell.dishImgBtn.hidden = false;
        [cell.dishImgBtn setImageWithUrl:[newsFeed thumbImageUrl] placeHolder:PJ_IMAGE_PLACEHOLDER forState:UIControlStateNormal completion:^(UIImage *image) {
        }];        
    }else if([newsFeed.type isEqualToString:@"follow"]){
        cell.delegate = self;
        cell.followingButton.hidden = false;
        cell.dishImgBtn.hidden = true;
        [cell updateFollowButton:[newsFeed.followBack boolValue]];
    }
    
    cell.messageLbl.text = newsFeed.message;
    [cell setTimeStamp:newsFeed.createdAt];
    cell.userNameLbl.text = newsFeed.userAlias;
    [cell.profileImgBtn setImageWithUrl:newsFeed.userPhoto placeHolder:PJ_IMAGE_PLACEHOLDER forState:UIControlStateNormal completion:^(UIImage *image) {
    }];

    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 16, 0, 16)];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 16, 0, 16)];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.destinationViewController isKindOfClass:[ProfileOtherViewController class]]){
        if([sender isKindOfClass:[User class]]){
            ((ProfileOtherViewController*)segue.destinationViewController).user = sender;
        }
    }
    
    else if([segue.destinationViewController isKindOfClass:[UploadedPhotoViewController class]]){
        if([sender isKindOfClass:[Dish class]]){
            ((UploadedPhotoViewController*)segue.destinationViewController).dish = sender;
            ((UploadedPhotoViewController*)segue.destinationViewController).enteredAsPushNavigation = true;
        }
    }
}


#pragma mark - NewsFeedDelegate

-(void)followWithCelltag:(NSInteger)tag{
    NewsFeedData *newsFeed = [self.dataArray objectAtIndex:tag];
    [self.view startLoading];
    [[APIManager sharedInstance] followUserWithId:newsFeed.relatedUser completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        NewsFeedCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        [cell updateFollowButton:true];
    }];
}

-(void)unFollowWithCellTag:(NSInteger)tag{
    NewsFeedData *newsFeed = [self.dataArray objectAtIndex:tag];
    [self.view startLoading];
    [[APIManager sharedInstance] unfollowUserWithId:newsFeed.relatedUser completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        NewsFeedCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
        [cell updateFollowButton:false];
    }];
}


#pragma mark - NewsFeed Delegate

-(void)userPressedDishImgBtn:(NSInteger)tag{
    NewsFeedData *newsFeed = [self.dataArray objectAtIndex:tag];
    if(newsFeed.relatedDish.length > 0){
        [self.view startLoading];
        [[APIManager sharedInstance] getDishWithId:newsFeed.relatedDish completion:^(BOOL success, Dish *response) {
            NSLog(@"newsFeed.relatedDish: %@", newsFeed.relatedDish);
            [self.view stopLoading];
            if(success){
                if(response)
                    [self performSegueWithIdentifier:@"uploadedPhotoSegue" sender:response];
            }
        }];
    }
}

-(void)userPressedProfileImgBtn:(NSInteger)tag{
    NewsFeedData *newsFeed = [self.dataArray objectAtIndex:tag];
    if(newsFeed.relatedUser.length > 0){
        [self.view startLoading];
        [[APIManager sharedInstance] getUserWithUserId:newsFeed.relatedUser completion:^(BOOL success, User *user) {
            NSLog(@"newsFeed.relatedUser: %@", newsFeed.relatedUser);
            [self.view stopLoading];
            if(success){
                if(user)
                    [self performSegueWithIdentifier:@"profileOtherSegue" sender:user];
            }
        }];
    }
}

#pragma mark - Push Notes
-(void)handleIncomingActivePushNotifications:(NSNotification *)note{
    [self synchronize];
}

@end
