//
//  ProfileOtherViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/8/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileOtherViewController.h"
#import "UIImageView+Online.h"
#import "UIView+Loading.h"
#import "APIManager.h"
#import "CDHelper.h"
#import "Constants.h"
#import "UIColor+PepperJelly.h"
#import "LikedPhotoViewController.h"
#import "MoreMenuViewController.h"
#import "NotificationManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileOtherViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet DesignableButton *followButton;

@end

@implementation ProfileOtherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([NotificationManager sharedManager].userEnteredAppFrtomRemoreNotification){
        [NotificationManager sharedManager].userId = nil;
    }
    
    NSLog(@"username: %@", self.user.userName);
    NSLog(@"user image: %@", self.user.userImage);

    
    self.uploadsButton.tag = 0;
    self.likedPhotosButton.tag = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
}

-(void)syncronize{
    //Username
    self.title = self.user.userName;
    
    //hides follow button in case it's self user
    self.followButton.hidden = [self.user.userId isEqualToString:[APIManager sharedInstance].user.userId];
    
    //Followers and Following
    [self updateFollowers];
    [self updateFollowing];
    
    [self.view startLoading];
    [[APIManager sharedInstance] getFollowersWithUser:self.user completion:^(BOOL success, APIResponse *response) {
        [self updateFollowers];
        
        [[APIManager sharedInstance] getFollowingWithUser:self.user completion:^(BOOL success, APIResponse *response) {
            [self.view stopLoading];
            
            [self updateFollowing];
        }];
    }];
    
    //Profile Picture
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.user.userImage] placeholderImage:PJ_IMAGE_PLACEHOLDER];
    //[self.profileImageView setImageWithUrl:self.user.userImage placeHolder:PJ_IMAGE_PLACEHOLDER completion:nil];
    
    //update follow button
    [self updateFollowButton:[[APIManager sharedInstance].user.followingUsers containsObject:self.user]];
    
    //reload Collection
    [self.collectionView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationController = segue.destinationViewController;
        if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[LikedPhotoViewController class]]){
            if([sender isKindOfClass:[Dish class]])
                ((LikedPhotoViewController*)[navigationController.viewControllers objectAtIndex:0]).dish = sender;
        }
    }else if([segue.destinationViewController isKindOfClass:[MoreMenuViewController class]]){
        ((MoreMenuViewController*)segue.destinationViewController).user = self.user;
    }else
        [super prepareForSegue:segue sender:sender];
}

#pragma mark - Events
- (IBAction)menuButtonPressed:(id)sender {
    
}

- (IBAction)followersButtonPressed:(id)sender {
    if(self.followerUsers.count == 0)
        return;
    
    self.followersCountButton.selected = !self.followersCountButton.selected;
    self.followingCountButton.selected = false;
    [self toggleFollowing];
    
    [self.followsTableView updateWithList:self.followerUsers];
}

- (IBAction)followingButtonPressed:(id)sender {
    if(self.followingUsers.count == 0)
        return;
    
    self.followingCountButton.selected = !self.followingCountButton.selected;
    self.followersCountButton.selected = false;
    [self toggleFollowing];
    
    [self.followsTableView updateWithList:self.followingUsers];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float moved = (self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
    int currentPage = startDragOffset.x > scrollView.contentOffset.x ? floor(moved) : ceil(moved);
    
    if(currentPage == self.uploadsButton.tag)
        [self updateTabSelectionWithButton:self.uploadsButton];
    else if(currentPage == self.likedPhotosButton.tag)
        [self updateTabSelectionWithButton:self.likedPhotosButton];
    
}

- (void)updateFollowers{
    [self.followerUsers removeAllObjects];
    [self.followerUsers addObjectsFromArray:[CDHelper sortArray:[self.user.followerUsers allObjects] by:@"fullName" ascending:YES]];
    [self.followersCountButton setTitle:[NSString stringWithFormat:@"%d", (int)self.followerUsers.count] forState:UIControlStateNormal];
    if(self.followersCountButton.selected){
        [self.followsTableView updateWithList:self.followerUsers];
        
        if(self.followerUsers.count == 0){
            self.followersCountButton.selected = false;
            [self toggleFollowing];
        }
    }
}

- (void)updateFollowing{
    [self.followingUsers removeAllObjects];
    [self.followingUsers addObjectsFromArray:[CDHelper sortArray:[self.user.followingUsers allObjects] by:@"fullName" ascending:YES]];
    [self.followingCountButton setTitle:[NSString stringWithFormat:@"%d", (int)self.followingUsers.count] forState:UIControlStateNormal];
    if(self.followingCountButton.selected){
        [self.followsTableView updateWithList:self.followingUsers];
    
        if(self.followingUsers.count == 0)
            self.followingCountButton.selected = false;
            [self toggleFollowing];
    }
    
}

- (IBAction)followButtonPressed:(id)sender {
    if([self.followButton.titleLabel.text isEqualToString:NSLocalizedString(@"unfollow", @"")]){
        [self.view startLoading];
        [[APIManager sharedInstance] unfollowUserWithId:self.user.userId completion:^(BOOL success, APIResponse *response) {
            [self.view stopLoading];
            [self updateFollowButton:!success];
        }];
    }else{
        [self.view startLoading];
        [[APIManager sharedInstance] followUserWithId:self.user.userId completion:^(BOOL success, APIResponse *response) {
            [self.view stopLoading];
            [self updateFollowButton:success];
        }];
    }
}

-(void)updateFollowButton:(BOOL)following{
    if(following){
        self.followButton.borderColor = [UIColor lightGrayColor];
        self.followButton.borderWidth = 2;
        self.followButton.backgroundColor = [UIColor whiteColor];
        [self.followButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.followButton setTitle:NSLocalizedString(@"unfollow", @"") forState:UIControlStateNormal];
    }else{
        self.followButton.borderColor = [UIColor clearColor];
        self.followButton.borderWidth = 0;
        self.followButton.backgroundColor = [UIColor followOrange];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followButton setTitle:NSLocalizedString(@"follow", @"") forState:UIControlStateNormal];
    }
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        ProfileUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"upload" forIndexPath:indexPath];
        cell.delegate = self;
        cell.user = self.user;
        [cell syncronize];
        return cell;
    }else{
        ProfileLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"like" forIndexPath:indexPath];
        cell.delegate = self;
        cell.user = self.user;
        [cell syncronize];
        return cell;
    }
}

#pragma mark - Profile Upload Delegate

-(void)didSelectUser:(User*)user{
//    //if it's the own user, return to previews screen
//    if([user.userId isEqual:[APIManager sharedInstance].user.userId]){
//        [self.navigationController popViewControllerAnimated:true];
//    }else{
        self.user = user;
        [self syncronize];
//    }
}
@end
