//
//  LikedPhotoViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "LikedPhotoViewController.h"
#import "GalleryPhotoTableViewCell.h"
#import "LikedDescriptionTableViewCell.h"
#import "UIView+Loading.h"
#import "UIImage+Online.h"
#import "UIImageView+Online.h"
#import "APIManager.h"
#import "RestaurantViewController.h"
#import "UIColor+PepperJelly.h"
#import "UITableViewCell+Online.h"
#import "ProfileOtherViewController.h"
#import "MoreMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LikedPhotoViewController () <LikedDescriptionDelegate, RestaurantDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LikedPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self syncronize];
}

-(void)syncronize{
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[self.dish thumbImageUrl]] placeholderImage:PJ_IMAGE_PLACEHOLDER];
    
    //restaurant
    self.restaurant = [Restaurant restaurantWithId:self.dish.restaurantId];
    [self.tableView reloadData];
    
    [self.view startLoading];
    [[APIManager sharedInstance] getRestaurantWithId:self.dish.restaurantId completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        self.restaurant = [Restaurant restaurantWithId:self.dish.restaurantId];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[RestaurantViewController class]]){
        ((RestaurantViewController*)segue.destinationViewController).dish = self.dish;
    }else if([segue.destinationViewController isKindOfClass:[ProfileOtherViewController class]]){
        ((ProfileOtherViewController*)segue.destinationViewController).user = self.dish.user;
    }else if([segue.destinationViewController isKindOfClass:[MoreMenuViewController class]]){
        ((MoreMenuViewController*)segue.destinationViewController).dish = self.dish;
        ((MoreMenuViewController*)segue.destinationViewController).restaurant = self.restaurant;
    }
}

#pragma mark - Events

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)menuButtonPressed:(id)sender {
    
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
        GalleryPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
        cell.delegate = self;
        cell.dish = self.dish;
        
        [cell.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]] forState:UIControlStateNormal];
        cell.likeButton.selected = [self.dish.currentUserLike boolValue];
        cell.likeButton.backgroundColor = cell.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
        
        //picture
        //[cell setImageWithUrl:self.dish.image placeHolder:PJ_IMAGE_PLACEHOLDER showLoading:true imageViewName:@"photoImageView" tableView:tableView indexPath:indexPath completion:nil];
        
        UIImageView *placeholder_image = [[UIImageView alloc] init];
        [placeholder_image sd_setImageWithURL:[NSURL URLWithString:[self.dish thumbImageUrl]]];
        
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[self.dish bigImageUrl]] placeholderImage:placeholder_image.image];
        
        return cell;
    }else if(indexPath.row == 1){
        LikedDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(self.dish.comments.count > 0) ? @"description" : @"descriptionNoComment" forIndexPath:indexPath];
        cell.delegate = self;
        cell.titleLabel.text = self.restaurant.name;
        cell.profileNameLabel.text = self.dish.user.userName;
        
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return [[UIScreen mainScreen] bounds].size.width;
    if(indexPath.row == 1)
        return 212;
    return 0;
}

#pragma mark - UploadedDescription Delegate

-(void)openRestaurant{
    [self performSegueWithIdentifier:@"restaurantSegue" sender:self];
}

#pragma mark -  Feed Delegate

-(void)likeDish:(BOOL)like{
    if(!like && self.closeOnUnlike)
        [self dismissViewControllerAnimated:true completion:nil];
}

@end
