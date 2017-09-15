//
//  MoreMenuViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "MoreMenuViewController.h"
#import "PJActivityItemProvider.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"
#import "User.h"
#import "APIManager.h"
#import "ReportMoreMenuViewController.h"

@interface MoreMenuViewController () <ReportMoreMenuDelegate> {
    BOOL didSelectOption;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *blockButton;

@end

@implementation MoreMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!self.user)
        self.user = self.dish.user;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.contentView.hidden = true;
    
    if(didSelectOption){
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showContent];
}

#pragma mark - Animations

-(void)showContent{
    self.contentView.hidden = false;
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height-self.contentView.frame.size.height-20, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height-self.contentView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)hideContentWithCompletion:(void (^)())completion{
    [UIView animateWithDuration:0.1f animations:^{
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height-self.contentView.frame.size.height-20, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.view.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:^(BOOL finished) {
            self.contentView.hidden = true;
            completion();
        }];
    }];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[ReportMoreMenuViewController class]]){
        ((ReportMoreMenuViewController*)segue.destinationViewController).reportDelegate = self;
        ((ReportMoreMenuViewController*)segue.destinationViewController).user = self.user;
        ((ReportMoreMenuViewController*)segue.destinationViewController).dish = self.dish;
    }
}

#pragma mark - Actions

- (IBAction)shareButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        didSelectOption = true;
        [self showShareSheet];
    }];
}

- (IBAction)reportButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        didSelectOption = true;
        [self showReportOptionSheet];
    }];
}

- (IBAction)blockButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        didSelectOption = true;
        [self reportUserWithUserId:self.user.userId];
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.view startLoading];
    [[APIManager sharedInstance] deleteDishWithId:self.dish.dishId completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        if(success){
            [self dismissViewControllerAnimated:true completion:^{
                [self.delegate moreMenuDidDeleteDish];
            }];
        }else{
            [self showAlertWithTitle:@"error_title" message:@"error_failed_deletedish"];
        }
    }];
}

-(void)showReportOptionSheet{
    [self performSegueWithIdentifier:@"reportPhotoSegue" sender:self];
}

-(void)showShareSheet{
    [self.view startLoading];
    [UIImage imageWithUrl:self.dish.image completion:^(UIImage *image) {
        [self.view stopLoading];
        
        NSString *urlStr = @"http://www.pepperjellyapp.com";
        NSString *generalText = [NSString stringWithFormat:@"%@\n%@\n%@", self.restaurant.name, self.restaurant.address, urlStr];
        NSString *twitterText = [NSString stringWithFormat:@"%@\n%@\n#pepperjelly #%@", self.restaurant.name, urlStr, [self.restaurant.name stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        PJActivityItemProvider *activityItem = [[PJActivityItemProvider alloc] initWithPlaceholderItem:generalText];
        activityItem.generalText = generalText;
        activityItem.twitterText = twitterText;
        
        NSArray *objectsToShare = @[image, activityItem];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        [self presentViewController:activityVC animated:YES completion:nil];
    }];
}

#pragma mark - ReportDelegate Delegate

-(void)reportCanceled{
    [self showContent];
}

-(void)reportDishWithDishId:(NSString *)dishId andWithReason:(NSString *)reason{
    [self.view startLoading];
    [[APIManager sharedInstance] flagDishWithId:dishId motive:reason completion:^(BOOL success, APIResponse *obj) {
        [self.view stopLoading];
        if(success){
            [self showAlertWithTitle:@"success_title" message:@"success_report_image"];
        }else{
            [self showAlertWithTitle:@"error_title" message:@"error_failed_report_image"];
        }
    }];
}

-(void)reportUserWithUserId:(NSString *)userId andWithReason:(NSString *)reason{
    [self.view startLoading];
    [[APIManager sharedInstance] userReportUserWithID:userId reason:reason completionHandler:^(BOOL success, APIResponse *obj) {
        [self.view stopLoading];
        if(success){
            [self showAlertWithTitle:@"success_title" message:@"success_report_profile"];
        }else{
            [self showAlertWithTitle:@"error_title" message:@"error_failed_report_profile"];
        }        
    }];
}

-(void)reportUserWithUserId:(NSString *)_id{
    [self.view startLoading];
    [[APIManager sharedInstance] userBlockUserWithID:_id completionHandler:^(BOOL success, APIResponse *obj) {
        [self.view stopLoading];
        if(success){
            [self showAlertWithTitle:@"success_title" message:@"success_block_profile"];
        }else{
            [self showAlertWithTitle:@"error_title" message:@"error_failed_block_profile"];
        }
    }];
}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, @"") message:NSLocalizedString(message, @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"error_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:true completion:^{
        
    }];
}

@end
