//
//  PublishPostViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PepperJelly-Swift.h" // Imports all swift files
#import "PublishPostViewController.h"
#import "DesignableTextField.h"
#import "DesignableButton.h"
#import "APIManager.h"
#import "UIView+Loading.h"
#import "AddCategoryViewController.h"
#import "AddRestaurantViewController.h"
#import "GooglePlace.h"
#import "UIImage+Cropping.h"
#import "DishImageData.h"
#import <Mixpanel/Mixpanel.h>
#import "PublishConfirmationViewController.h"
@import MBProgressHUD;

#define formUpperEditingMargin 100
#define formAnimationTime 0.25f
#define captionTextLimit 200
#define keyboardHeight 253

@interface PublishPostViewController () <UITextViewDelegate>{
    BOOL editing;
}

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *captionIconImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIconImageView;
@property (weak, nonatomic) IBOutlet DesignableButton *postButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *restaurantLbl;
@property (weak, nonatomic) IBOutlet CosmosView *ratingView;
@property (strong, nonatomic) GooglePlace *googlePlace;
@property (assign, nonatomic) BOOL categorySet;
@property (assign, nonatomic) BOOL resaurantSet;
@property (assign, nonatomic) BOOL searching;
@property (strong, nonatomic)NSArray *categoriesArray;

- (IBAction)addRestaurantBtnTapped:(UIButton *)sender;
- (IBAction)addCategoryBtnTapped:(UIButton *)sender;

@end

@implementation PublishPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoImageView.image = self.postImage;
    self.photoImageView.layer.masksToBounds = true;
    [self.captionTextView setTextContainerInset:UIEdgeInsetsMake(14, 14, 14, 14)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing];
}

#pragma mark - Navigation
-(IBAction)unwindToPublish:(UIStoryboardSegue *)segue{
    NSLog(@"unwind");
    if([segue.sourceViewController isKindOfClass:[AddCategoryViewController class]]){
        AddCategoryViewController *vc = (AddCategoryViewController *)segue.sourceViewController;
        self.categorySet = true;
        self.categoriesArray = vc.selectedCategoriesArray;
        
        self.categoryLbl.text = @"";
        for(NSString *categoryName in self.categoriesArray){
            if(self.categoryLbl.text.length > 0)
                self.categoryLbl.text = [self.categoryLbl.text stringByAppendingString:@", "];
            self.categoryLbl.text = [self.categoryLbl.text stringByAppendingString:categoryName];
        }
    }
    
    else if([segue.sourceViewController isKindOfClass:[AddRestaurantViewController class]]){
        AddRestaurantViewController *vc = (AddRestaurantViewController *)segue.sourceViewController;
        self.resaurantSet = true;
        self.googlePlace = vc.selectedRestaurant;
        self.restaurantLbl.text = self.googlePlace.placeDescription;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self endEditing];
    
    if([segue.destinationViewController isKindOfClass:[AddCategoryViewController class]]){
        AddCategoryViewController *vc = (AddCategoryViewController *)segue.destinationViewController;
        vc.selectedCategoriesArray = [[NSMutableArray alloc] initWithArray:self.categoriesArray];
    } else if ([segue.destinationViewController isKindOfClass:[PublishConfirmationViewController class]]) {
        PublishConfirmationViewController *vc = (PublishConfirmationViewController *)segue.destinationViewController;
        vc.publishedImage = self.postImage;
    }
}

#pragma mark - Events

- (IBAction)addRestaurantBtnTapped:(UIButton *)sender {
    [self endEditing];
}

- (IBAction)addCategoryBtnTapped:(UIButton *)sender {
    [self endEditing];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)postButtonPressed:(id)sender {
    [self endEditing];
 
    if(self.captionTextView.text.length == 0){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_caption", @"") viewController:self];
        return;
    }
    
    if(!self.resaurantSet){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_restaurant", @"") viewController:self];
        return;
    }
    
    if(!self.categorySet){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_category", @"") viewController:self];
        return;
    }
    
    if (self.ratingView.rating == 0) {
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_rating", @"") viewController:self];
        return;
    }
    
    [self publish];
}

-(void)moveContentForEditing:(BOOL)shouldEdit view:(UIView*)view{
    editing = shouldEdit;
    
    //makes sure it won't move more than the keyboard size
    CGRect moveToRect = CGRectMake(self.contentView.frame.origin.x, (editing ? -view.frame.origin.y+formUpperEditingMargin : 0), self.contentView.frame.size.width, self.contentView.frame.size.height);
    if(moveToRect.origin.y < -keyboardHeight)
        moveToRect.origin.y = -keyboardHeight;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = true;
    [UIView animateWithDuration:formAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.frame = moveToRect;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)endEditing{
    [self.captionTextView resignFirstResponder];
    [self moveContentForEditing:false view:nil];
}

-(void)publish{
    
    NSArray *sizes = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGSize:IMAGE_SIZE_FEED_BIG],
                      [NSValue valueWithCGSize:IMAGE_SIZE_FEED_MEDIUM],
                      [NSValue valueWithCGSize:IMAGE_SIZE_FEED_THUMBNAIL], nil];
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[APIManager sharedInstance] userUploadPhoto:self.postImage withSizes:sizes urls:[NSArray new] completionHandler:^(BOOL success, NSMutableArray *imageURLS) {
        if(success) {
            [[APIManager sharedInstance] createDishWithImage:imageURLS googleplaceId:self.googlePlace.placeId caption:self.captionTextView.text categories:self.categoriesArray rating:[NSNumber numberWithDouble:self.ratingView.rating] completion:^(BOOL success, APIResponse *response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
                
                if(success){
                    [[Mixpanel sharedInstance] track:@"Published Dish"];
                    [[Mixpanel sharedInstance].people increment:@"Posts" by:@1];
                    // UIImageWriteToSavedPhotosAlbum(self.postImage, nil, nil, nil);
                    [self showPostedScreen];
                }else{
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_uploadimage_title", @"") message:response.SERVER_ERROR viewController:self];
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_uploadimage_title", @"") message:NSLocalizedString(@"error_failed_uploadimage", @"") viewController:self];
        }
    }];
}

-(void)showPostedScreen{
    //Opens the confirmation screen according to the size of screen
    if([[UIScreen mainScreen] bounds].size.width < 375)
        [self performSegueWithIdentifier:@"confirmationSmallSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"confirmationSegue" sender:self];
}

#pragma mark - TextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if(textView == self.captionTextView){
        //hides placeholder
        [UIView animateWithDuration:formAnimationTime animations:^{
            self.captionLabel.alpha = 0;
        }completion:^(BOOL finished) {
            self.captionLabel.alpha = 1;
            self.captionLabel.hidden = true;
        }];
        
        [self moveContentForEditing:true view:textView];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if(textView == self.captionTextView){
        if(self.captionTextView.text.length == 0){
            self.captionLabel.hidden = false;
            [UIView animateWithDuration:formAnimationTime animations:^{
                self.captionLabel.alpha = 1;
            }];
        }
        
        [self moveContentForEditing:false view:textView];
        [textView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(textView == self.captionTextView)
        return textView.text.length + (text.length - range.length) <= captionTextLimit;
    
    return true;
}


@end
