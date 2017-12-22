//
//  ProfileViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "UIView+Loading.h"
#import "UIImageView+Online.h"
#import "ProfileOtherViewController.h"
#import "LikedPhotoViewController.h"
#import "UploadedPhotoViewController.h"
#import "RestaurantViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //disables so we can enable it in the child scrollviews
    self.collectionView.scrollsToTop = false;
    
    self.savedButton.tag = 0;
    self.uploadsButton.tag = 1;
    self.likedPhotosButton.tag = 2;
    firstTime = true;
    
    self.followsTableView.profileDelegate = self;
    
    self.followerUsers = [[NSMutableArray alloc] init];
    self.followingUsers = [[NSMutableArray alloc] init];
    
    
    [self configureUI];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self syncronize];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(firstTime)
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.uploadsButton.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    firstTime = false;
}

-(void)configureUI{
    self.likedPhotosButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.likedPhotosButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.likedPhotosButton setTitle:@"PEPPERED\nPHOTOS" forState:UIControlStateNormal];
}

#pragma mark - Services

- (void)syncronize{
    //Username
    self.title = [APIManager sharedInstance].user.userName;
    
    //Followers and Following
    [self updateFollowers];
    [self updateFollowing];
    
    [[APIManager sharedInstance] getFollowersWithUser:[APIManager sharedInstance].user completion:^(BOOL success, APIResponse *response) {
        [self updateFollowers];
    }];
    
    [[APIManager sharedInstance] getFollowingWithUser:[APIManager sharedInstance].user completion:^(BOOL success, APIResponse *response) {
        
        [self updateFollowing];
    }];
    
    //Profile Picture
    [self.profileImageView setImageWithUrl:[APIManager sharedInstance].user.userImage placeHolder:PJ_IMAGE_PLACEHOLDER completion:nil];
    
    //update current tab
    [self.collectionView reloadData];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *strUserBio = [[NSString alloc] init];
    if ([APIManager sharedInstance].user.userBio != nil){
        strUserBio = [APIManager sharedInstance].user.userBio;
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strUserBio attributes: @{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    
    self.userBioLabel.attributedText = attributeString;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[ProfileOtherViewController class]]){
        if([sender isKindOfClass:[User class]])
            ((ProfileOtherViewController*)segue.destinationViewController).user = sender;
    }else if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navigationController = segue.destinationViewController;
        if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[UploadedPhotoViewController class]]){
            if([sender isKindOfClass:[Dish class]])
                ((UploadedPhotoViewController*)[navigationController.viewControllers objectAtIndex:0]).dish = sender;
        }else if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[LikedPhotoViewController class]]){
            if([sender isKindOfClass:[Dish class]])
                ((LikedPhotoViewController*)[navigationController.viewControllers objectAtIndex:0]).dish = sender;
            ((LikedPhotoViewController*)[navigationController.viewControllers objectAtIndex:0]).closeOnUnlike = true;
        }
    }else if([segue.destinationViewController isKindOfClass:[RestaurantViewController class]]){
        if([sender isKindOfClass:[Restaurant class]])
            ((RestaurantViewController*)segue.destinationViewController).restaurant = sender;
    }
}

#pragma mark - Events

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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

- (void)toggleFollowing{
    if (self.followersCountButton.selected || self.followingCountButton.selected){
        
        self.backgroundView.hidden = true;
        
        //does not animate case it's already visible
        if(!self.followsTableView.hidden)
            return;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.savedButton.alpha = 0;
            self.uploadsButton.alpha = 0;
            self.likedPhotosButton.alpha = 0;
            self.selectedButtonView.alpha = 0;
        }completion:^(BOOL finished) {
            self.savedButton.hidden = true;
            self.uploadsButton.hidden = true;
            self.likedPhotosButton.hidden = true;
            self.selectedButtonView.hidden = true;
        }];
        
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.collectionView.center = CGPointMake(self.collectionView.center.x, self.collectionView.center.y-20);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.collectionView.center = CGPointMake(self.collectionView.center.x, self.view.frame.size.height+self.collectionView.frame.size.height/2);
            } completion:^(BOOL finished) {
                self.collectionView.hidden = true;
            }];
            
            self.followsTableView.hidden = false;
            self.followsTableView.center = CGPointMake(self.followsTableView.center.x, self.view.frame.size.height+self.followsTableView.frame.size.height/2);
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.followsTableView.center = CGPointMake(self.followsTableView.center.x, self.view.frame.size.height-self.followsTableView.frame.size.height/2);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        
        self.backgroundView.hidden = false;
        self.savedButton.hidden = false;
        self.uploadsButton.hidden = false;
        self.likedPhotosButton.hidden = false;
        self.selectedButtonView.hidden = false;
        [UIView animateWithDuration:0.3f animations:^{
            self.savedButton.alpha = 1;
            self.uploadsButton.alpha = 1;
            self.likedPhotosButton.alpha = 1;
            self.selectedButtonView.alpha = 1;
        }completion:^(BOOL finished) {
            
        }];
        
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.followsTableView.center = CGPointMake(self.followsTableView.center.x, self.followsTableView.center.y-20);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.followsTableView.center = CGPointMake(self.followsTableView.center.x, self.view.frame.size.height+self.followsTableView.frame.size.height/2);
            } completion:^(BOOL finished) {
                self.followsTableView.hidden = true;
            }];
            
            self.collectionView.hidden = false;
            self.collectionView.center = CGPointMake(self.collectionView.center.x, self.view.frame.size.height+self.collectionView.frame.size.height/2);
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.collectionView.center = CGPointMake(self.collectionView.center.x, self.view.frame.size.height-self.collectionView.frame.size.height/2);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (IBAction)configButtonPressed:(id)sender {
}

- (IBAction)savedButtonPressed:(id)sender {
    [self updateTabSelectionWithButton:sender];
}

- (IBAction)uploadsButtonPressed:(id)sender {
    [self updateTabSelectionWithButton:sender];
}

- (IBAction)likedPhotosButtonPressed:(id)sender {
    [self updateTabSelectionWithButton:sender];
}

-(void)updateTabSelectionWithButton:(UIButton*)button{
    self.savedButton.selected = false;
    self.uploadsButton.selected = false;
    self.likedPhotosButton.selected = false;
    
    float force = 10;
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.selectedButtonView.center = CGPointMake(button.center.x > self.selectedButtonView.center.x ? self.selectedButtonView.center.x-force : self.selectedButtonView.center.x+force, self.selectedButtonView.center.y);
    } completion:^(BOOL finished) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            button.selected = true;
            self.selectedButtonView.center = CGPointMake(button.center.x, self.selectedButtonView.center.y);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)updateFollowers{
    [self.followerUsers removeAllObjects];
    [self.followerUsers addObjectsFromArray:[CDHelper sortArray:[[APIManager sharedInstance].user.followerUsers allObjects] by:@"fullName" ascending:YES]];
    [self.followersCountButton setTitle:[NSString stringWithFormat:@"%d", (int)self.followerUsers.count] forState:UIControlStateNormal];
    if(self.followersCountButton.selected)
        [self.followsTableView updateWithList:self.followerUsers];
}

- (void)updateFollowing{
    [self.followingUsers removeAllObjects];
    [self.followingUsers addObjectsFromArray:[CDHelper sortArray:[[APIManager sharedInstance].user.followingUsers allObjects] by:@"fullName" ascending:YES]];
    [self.followingCountButton setTitle:[NSString stringWithFormat:@"%d", (int)self.followingUsers.count] forState:UIControlStateNormal];
    if(self.followingCountButton.selected)
        [self.followsTableView updateWithList:self.followingUsers];
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        ProfileSavedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"saved" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else if(indexPath.row == 1){
        ProfileUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"upload" forIndexPath:indexPath];
        cell.delegate = self;
        cell.user = [APIManager sharedInstance].user;
        [cell syncronize];
        return cell;
    }else{
        ProfileLikeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"like" forIndexPath:indexPath];
        cell.delegate = self;
        cell.user = [APIManager sharedInstance].user;
        [cell syncronize];
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    startDragOffset = scrollView.contentOffset;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float moved = (self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
    int currentPage = startDragOffset.x > scrollView.contentOffset.x ? floor(moved) : ceil(moved);
    
    if(currentPage == self.savedButton.tag)
        [self updateTabSelectionWithButton:self.savedButton];
    else if(currentPage == self.uploadsButton.tag)
        [self updateTabSelectionWithButton:self.uploadsButton];
    else if(currentPage == self.likedPhotosButton.tag)
        [self updateTabSelectionWithButton:self.likedPhotosButton];
    
}

#pragma mark - Profile Upload Delegate

-(void)openUploadedPhoto:(Dish *)dish{
    [self performSegueWithIdentifier:@"uploadedPhotoSegue" sender:dish];
}

-(void)openLikedPhoto:(Dish *)dish{
    [self performSegueWithIdentifier:@"likedPhotoSegue" sender:dish];
}

-(void)openRestaurant:(Restaurant *)restaurant{
    Search *search = [[Search alloc] init];
    search.restaurantId = restaurant.restaurantId;
    [[APIManager sharedInstance] searchDishesWithSearch:search completion:^(BOOL success, APIResponse *response) {
        [self performSegueWithIdentifier:@"restaurantSegue" sender:restaurant];
    }];
}

-(void)didSelectUser:(User*)user{
    [self performSegueWithIdentifier:@"userSegue" sender:user];
}

-(void)openPublish{
    [self performSegueWithIdentifier:@"publishSegue" sender:self];
}

-(void)followUser:(User *)user{
    [self.view startLoading];
    [[APIManager sharedInstance] followUserWithId:user.userId completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        [self.followsTableView reload];
        [self updateFollowing];
    }];
}

-(void)unfollowUser:(User *)user{
    [self.view startLoading];
    [[APIManager sharedInstance] unfollowUserWithId:user.userId completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        [self.followsTableView reload];
        [self updateFollowing];
    }];
}


@end
