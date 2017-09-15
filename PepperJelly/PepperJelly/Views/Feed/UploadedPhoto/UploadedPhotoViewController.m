//
//  UploadedPhotoViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UploadedPhotoViewController.h"
#import "UploadedPhotoTableViewCell.h"
#import "UploadedDescriptionTableViewCell.h"
#import "UIView+Loading.h"
#import "UIImage+Online.h"
#import "UIImageView+Online.h"
#import "APIManager.h"
#import "RestaurantViewController.h"
#import "UITableViewCell+Online.h"
#import "UIColor+PepperJelly.h"
#import "MoreMenuViewController.h"
#import "NotificationManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UploadedPhotoViewController () <UploadedPhotoDelegate, UploadedDescriptionDelegate, UITableViewDelegate, UITableViewDataSource, MoreMenuDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UploadedPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check for push notification
    if([NotificationManager sharedManager].userEnteredAppFrtomRemoreNotification){
        [NotificationManager sharedManager].dishId = nil;
    }
    
    [self syncronize];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}


-(void)syncronize{
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[self.dish thumbImageUrl]] placeholderImage:PJ_IMAGE_PLACEHOLDER];
    
    //restaurant
    self.restaurant = [Restaurant restaurantWithId:self.dish.restaurantId];
    [self.tableView reloadData];
    
    //[self.view startLoading];
    //[self.view stopLoading];
    [[APIManager sharedInstance] getRestaurantWithId:self.dish.restaurantId completion:^(BOOL success, APIResponse *response) {
        //[self.view stopLoading];
        
        self.restaurant = [Restaurant restaurantWithId:self.dish.restaurantId];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[RestaurantViewController class]]){
        ((RestaurantViewController*)segue.destinationViewController).dish = self.dish;
    }else if([segue.destinationViewController isKindOfClass:[MoreMenuViewController class]]){
        ((MoreMenuViewController*)segue.destinationViewController).dish = self.dish;
        ((MoreMenuViewController*)segue.destinationViewController).restaurant = self.restaurant;
        ((MoreMenuViewController*)segue.destinationViewController).delegate = self;
    }
}

#pragma mark - Events

- (IBAction)closeButtonPressed:(id)sender {
    if(self.enteredAsPushNavigation){
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
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
        UploadedPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photo" forIndexPath:indexPath];
        
        [cell configWithDish:self.dish andDelegate:self];
        
        UIImageView *placeholder_view = [[UIImageView alloc] init];
        [placeholder_view sd_setImageWithURL:[NSURL URLWithString:[self.dish thumbImageUrl]]];
        
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[self.dish bigImageUrl]] placeholderImage:placeholder_view.image];

        return cell;
    }else if(indexPath.row == 1){
        UploadedDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(self.dish.comments.count > 0) ? @"description" : @"descriptionNoComment" forIndexPath:indexPath];
        cell.delegate = self;
        
        cell.titleLabel.text = self.restaurant.name;
        
        //caption
        cell.descLabel.text = @"";
        if(self.dish.comments.count > 0){
            Comment *comment = [[self.dish.comments allObjects] objectAtIndex:0];
            cell.descLabel.text = comment.comment;
        }
        
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
        return (self.dish.comments.count > 0) ? 176 : 126;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0)
        return [[UIScreen mainScreen] bounds].size.width;
    if(indexPath.row == 1)
        return (self.dish.comments.count > 0) ? UITableViewAutomaticDimension : 126;
    return 0;
}

#pragma mark - UploadedPhoto Delegate

-(void)deleteUploadedPhoto{
}

-(void)likeDish:(BOOL)like{
}

#pragma mark - MoreMenu Delegate

-(void)moreMenuDidDeleteDish{
    [self closeButtonPressed:self];
}

#pragma mark - UploadedDescription Delegate

-(void)openRestaurant{
    [self performSegueWithIdentifier:@"restaurantSegue" sender:self];
}

@end
