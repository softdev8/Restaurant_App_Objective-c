//
//  SignUpReviewViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PepperJelly-Swift.h" // Imports all swift files
#import "SignUpReviewViewController.h"
#import "DesignableButton.h"
#import "CameraChoiceViewController.h"
#import "UIView+Borders.h"
#import "UIColor+PepperJelly.h"
#import "APIManager.h"
#import "UIView+Loading.h"
#import "LocationsViewController.h"
#import "Constants.h"
#import "UIButton+Online.h"
#import "UIImage+Cropping.h"
#import <Mixpanel/Mixpanel.h>

@interface SignUpReviewViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraChoiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *defaultLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultDistanceButton;
@property (weak, nonatomic) IBOutlet DesignableButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet DesignableButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *defaultLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (nonatomic, strong) DropDown *distanceDropdown;
@property (nonatomic, strong) NSArray *distanceOptions;

@end

@implementation SignUpReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

-(void)viewDidLayoutSubviews{
    [self.usernameTextField addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
    [self.defaultLocationButton addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
    [self.defaultDistanceButton addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.usernameTextField resignFirstResponder];
}

-(void)configureUI{
    if([[APIManager sharedInstance].user.userImage respondsToSelector:@selector(length)]){
        [self.profilePictureButton setImageWithUrl:[APIManager sharedInstance].user.userImage placeHolder:PJ_IMAGE_PLACEHOLDER forState:UIControlStateNormal completion:^(UIImage *image) {
        }];
        
        self.profilePictureButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.profilePictureButton.layer.masksToBounds = true;
    }

    
    self.searchOptions = [[Search alloc] init];
    NSMutableArray *dropdownDatasource = [NSMutableArray array];
    for (int i = 1; i <= 10; i++) {
        if (i == 1) {
            [dropdownDatasource addObject:[NSString stringWithFormat:@"1 mile"]];
            continue;
        }
        [dropdownDatasource addObject:[NSString stringWithFormat:@"%d miles", i]];
        
    }
    self.distanceDropdown = [[DropDown alloc] init];
    self.distanceDropdown.anchorView = self.rangeLabel;
    self.distanceDropdown.dataSource = [dropdownDatasource copy];
    self.distanceDropdown.topOffset = CGPointMake(0, 30.0);
    [[DropDown appearance] setTextFont:[UIFont fontWithName:@"Lato-Regular" size:14.0]];
    
    __block SignUpReviewViewController *weakSelf = self;
    [self.distanceDropdown setSelectionAction:^(NSInteger index, NSString * _Nonnull item) {
        NSLog(@"Selected index %ld", (long)index);
        [weakSelf setNewDistance:(int)index + 1]; // Add one to index value for the number of miles the user selected.
    }];
    [self setNewDistance:10];
}

- (void)setNewDistance:(int)value {
    NSLog(@"Value: %d", value);
    NSString *distanceString;
    if (value == 1) {
        distanceString = [NSString stringWithFormat:@"%d mile", value];
    } else {
        distanceString = [NSString stringWithFormat:@"%d miles", value];
    }
    self.rangeLabel.text = distanceString;
    self.searchOptions.range = [NSNumber numberWithInt:value * 1609]; // Save distance as meters
}

- (IBAction)changeDistancePressed:(UIButton *)sender {
    [self.distanceDropdown show];
}

#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"tutorialSegue"] || [identifier isEqualToString:@"tutorialSmallSegue"]){
        if(![APIManager isValidEmail:self.usernameTextField.text]){
            [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_email", @"") viewController:self];
            return false;
        }
        
        return true;
    }
    return true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[CameraChoiceViewController class]]){
        ((CameraChoiceViewController*)segue.destinationViewController).delegate = self;
    }
    
    else if([segue.destinationViewController isKindOfClass:[LocationsViewController class]]){
        ((LocationsViewController*)segue.destinationViewController).enteredFromSubmitReview = true;
    }
}

#pragma mark - Events
- (IBAction)profilePictureButtonPressed:(id)sender {
}

- (IBAction)defaultLocationButtonPressed:(id)sender {
}

- (IBAction)defaultDistanceButtonPressed:(id)sender {
}

- (IBAction)confirmButtonPressed:(id)sender {
    BOOL hasImage = self.profilePictureButton.selected;
    BOOL hasUploadedImage = ([APIManager sharedInstance].user.userImage && [APIManager sharedInstance].user.userImage.length > 0);
    NSLog(@"image: %@", [APIManager sharedInstance].user.userImage);
    
    //only proceeds if either doesn't have an image OR has an image and has uploaded it
    if(hasImage && !hasUploadedImage)
        return;
    
    NSLog(@"Submit Review: username: %@", self.usernameTextField.text);
    NSLog(@"Submit Review: email: %@", [APIManager sharedInstance].user.email);
    NSLog(@"Submit Review: location: %@", self.selectedLocation);
    NSLog(@"Submit Review: Address: %@", self.selectedAddress);
    NSLog(@"Submit Review: Search range: %d", [self.searchOptions.range intValue]);
    
    //only proceeds to tutorial if has username
    if(self.usernameTextField.text.length == 0){
        [APIManager showAlertWithTitle:NSLocalizedString(@"signup_setusername_title", @"") message:NSLocalizedString(@"signup_setusername", @"") viewController:self];
        return;
    }
    
    //only proceed if user has set location
    if(!self.selectedLocation){
        [APIManager showAlertWithTitle:NSLocalizedString(@"signup_setlocation_title", @"") message:NSLocalizedString(@"signup_setlocation", @"") viewController:self];
        return;
    }
    
    [[Mixpanel sharedInstance] track:@"Registered"];
    NSMutableDictionary *traitsDict = [NSMutableDictionary dictionary];
    User *userMP = [APIManager sharedInstance].user;
    if(userMP.fullName)
        traitsDict[@"$name"] = userMP.fullName;
    if(userMP.email)
        traitsDict[@"$email"] = userMP.email;
    if(userMP.locationLatitude)
        traitsDict[@"Latitude"] = userMP.locationLatitude;
    if(userMP.locationLongitude)
        traitsDict[@"Longitude"] = userMP.locationLongitude;
    traitsDict[@"Registered"] = [NSNumber numberWithBool:YES];
    traitsDict[@"Registered Date"] = [NSDate date];
    [[Mixpanel sharedInstance] identify:userMP.userId];
    [[Mixpanel sharedInstance].people set:[traitsDict copy]];
    
    UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
    [user setLatitude:self.selectedLocation.coordinate.latitude andLongitude:self.selectedLocation.coordinate.longitude];
    user.range = self.searchOptions.range;
    user.locationName = self.selectedAddress;
    user.userName = self.usernameTextField.text;
    
    [self.view startLoading];
    [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        if(success){
            //Opens the tutorial screen according to the size of screen
            if([[UIScreen mainScreen] bounds].size.width < 375)
                [self performSegueWithIdentifier:@"tutorialSmallSegue" sender:self];
            else
                [self performSegueWithIdentifier:@"tutorialSegue" sender:self];
        }else{
            if([response.SERVER_ERROR containsString:@"duplicate key error"])
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_changeusername", @"") viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_save", @"") viewController:self];
        }
    }];
}

-(IBAction)unwindToSignUpReview:(UIStoryboardSegue *)segue{
    if([segue.sourceViewController isKindOfClass:[LocationsViewController class]]){
        LocationsViewController *vc = (LocationsViewController *)segue.sourceViewController;
        self.selectedAddress =  [vc.selectedLocation objectForKey:@"address"];
        self.selectedLocation = [vc.selectedLocation objectForKey:@"location"];
        self.defaultLocationLabel.text = self.selectedAddress;
    }
}

-(void)uploadUserPhotos:(UIImage *)img{
    [self.view startLoadingAfterDelay:0.0];
    [[APIManager sharedInstance] userUploadPhoto:[UIImage squareImageWithImage:img scaledToSize:IMAGE_SIZE_PROFILE] completionHandler:^(BOOL success, NSString *url){
        if(success){
            UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
            user.pictures = [NSArray arrayWithObjects:url, nil];
            
            [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
                [self.view stopLoading];
                
                if(success){
                    [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_uploadimage", @"") viewController:self];
                }else{
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_uploadimage_title", @"") message:response.error viewController:self];
                    self.profilePictureButton.selected = false;
                }
            }];
        }else{
            [self.view stopLoading];
            [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_uploadimage_title", @"") message:NSLocalizedString(@"error_failed_uploadimage", @"") viewController:self];
            self.profilePictureButton.selected = false;
        }
    }];
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.usernameTextField)
        [self.usernameTextField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.usernameTextField){
        if([string isEqualToString:@" "])
            return NO;
    }
    return YES;
}

#pragma mark - CameraChoiceDelegate
-(void)cameraOptionSelected:(CameraOptions)option{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = option == CameraOptionCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
    [self.profilePictureButton setImage:image forState:UIControlStateSelected];
    self.profilePictureButton.selected = true;
    self.profilePictureButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePictureButton.layer.masksToBounds = true;
    [self uploadUserPhotos:image];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}
@end
