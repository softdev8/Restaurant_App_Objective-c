//
//  GalleryPhotoViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "GalleryPhotoViewController.h"
#import "GalleryPhotoTableViewCell.h"
#import "RestaurantPhotoDetailsTableViewCell.h"
#import "UIImageView+Online.h"
#import "UITableViewCell+Online.h"
#import "APIManager.h"
#import "ProfileOtherViewController.h"
#import "UIView+Loading.h"
#import "MoreMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GalleryPhotoViewController () <RestaurantDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GalleryPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getRestaurantData];
    [self syncronize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}

-(void)syncronize{
    //[self.backgroundImageView setImageWithUrl:[self.dish bigImageUrl] placeHolder:PJ_IMAGE_PLACEHOLDER completion:nil];
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[self.dish thumbImageUrl]] placeholderImage:PJ_IMAGE_PLACEHOLDER];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[ProfileOtherViewController class]]){
        ((ProfileOtherViewController*)segue.destinationViewController).user = self.dish.user;
    }else if([segue.destinationViewController isKindOfClass:[MoreMenuViewController class]]){
        ((MoreMenuViewController*)segue.destinationViewController).dish = self.dish;
        ((MoreMenuViewController*)segue.destinationViewController).restaurant = self.restaurant;
    }
}

#pragma mark - Events

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)menuButtonPressed:(id)sender {
}

-(void)getRestaurantData{
    self.restaurant = [Restaurant restaurantWithId:self.dish.restaurantId];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        RestaurantPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
        cell.delegate = self;
        cell.dish = self.dish;
        [cell.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]] forState:UIControlStateNormal];
        
        [cell setImageWithUrl:self.dish.image placeHolder:PJ_IMAGE_PLACEHOLDER showLoading:true imageViewName:@"photoImageView" tableView:tableView indexPath:indexPath completion:nil];

        
        return cell;
    }else if(indexPath.row == 1){
        RestaurantPhotoDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(self.dish.comments.count > 0) ? @"photoDetails" : @"photoDetailsNoComment" forIndexPath:indexPath];
        cell.delegate = self;
        cell.profileName.text = self.dish.user.userName;
        
        //caption
        cell.descLabel.text = @"";
        if(self.dish.comments.count > 0){
            Comment *comment = [[self.dish.comments allObjects] objectAtIndex:0];
            cell.descLabel.text = [NSString stringWithFormat:@"\"%@\"", comment.comment];;
        }
        
        //profile picture
        [cell setImageWithUrl:self.dish.user.userImage placeHolder:PJ_IMAGE_PLACEHOLDER showLoading:true imageViewName:@"profileImageView" tableView:tableView indexPath:indexPath completion:nil];
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row == 2){
            [UIView animateWithDuration:0.3f animations:^{
                self.tableView.contentOffset = CGPointMake(0, 0);
            }];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return [[UIScreen mainScreen] bounds].size.width;
    if(indexPath.row == 1)
        return (self.dish.comments.count > 0) ? 161 : 111;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return [[UIScreen mainScreen] bounds].size.width;
    if(indexPath.row == 1)
        return (self.dish.comments.count > 0) ? UITableViewAutomaticDimension : 111;
    return 0;
}

#pragma mark - Restaurant Delegate

-(void)likeDish:(BOOL)like{
    
}


@end
