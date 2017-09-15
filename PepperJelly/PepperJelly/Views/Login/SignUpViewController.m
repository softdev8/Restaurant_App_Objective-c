//
//  SignUpViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "SignUpViewController.h"
#import "NSString+AttributedString.h"
#import "UIColor+PepperJelly.h"
#import "UIView+Borders.h"
#import "APIManager.h"
#import "SignUpReviewViewController.h"
#import "UIView+Loading.h"
#import "GoogleSignInHelper.h"
#import "FacebookLoginHelper.h"
#import <Mixpanel/Mixpanel.h>

@interface SignUpViewController () <UITextFieldDelegate, GIDSignInUIDelegate, GoogleSignHelperDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialMediaLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailTextField.text = self.email;
    
    [self.signInButton setAttributedTitle:[NSString attributedStringWith: [[NSArray alloc] initWithObjects:
                                                                           [[AttributedText alloc] initWithText:NSLocalizedString(@"signup_hasaccount_1", @"") andAttribute:@{NSForegroundColorAttributeName:[UIColor greyishBrownColor]}],
                                                                           [[AttributedText alloc] initWithText:NSLocalizedString(@"signup_hasaccount_2", @"") andAttribute:@{NSForegroundColorAttributeName:[UIColor pepperjellyPinkColor]}],
                                                                           nil]] forState:UIControlStateNormal];
    
    [GoogleSignInHelper sharedInstance].delegate = self;    
    
}

-(void)viewDidLayoutSubviews{
    [self.nameTextField addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
    [self.emailTextField addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
    [self.passwordTextField addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[SignUpReviewViewController class]]){
        ((SignUpReviewViewController*) segue.destinationViewController).name = self.nameTextField.text;
        ((SignUpReviewViewController*) segue.destinationViewController).email = self.emailTextField.text;
        ((SignUpReviewViewController*) segue.destinationViewController).password = self.passwordTextField.text;
    }
}

#pragma mark - Events


- (IBAction)signUpButtonPressed:(id)sender {
    if(![APIManager isValidEmail:self.emailTextField.text]){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_email", @"") viewController:self];
        return;
    }
    if(![APIManager isValidName:self.nameTextField.text]){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_name", @"") viewController:self];
        return;
    }
    if(![APIManager isValidPassword:self.passwordTextField.text]){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_password", @"") viewController:self];
        return;
    }
    
    [self.view startLoading];
    [APIManager.sharedInstance signUpWithName:self.nameTextField.text email:self.emailTextField.text password:self.passwordTextField.text completion:^(BOOL success, APIResponse* response) {
        [self.view stopLoading];
        
        if(success){
            [self performSegueWithIdentifier:@"reviewSegue" sender:self];
        }else{
            if(response.error.length > 0){
                NSString *message = response.error;
                if([message containsString:@"exists"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:NSLocalizedString(@"error_failed_register", @"") preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self performSegueWithIdentifier:@"forgotPasswordSegue" sender:self];
                    }];
                    [alertController addAction:yesAction];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self performSegueWithIdentifier:@"loginSegue" sender:self];
                    }];
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:true completion:^{
                        
                    }];
                }else
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:response.error viewController:self];
            }else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}

- (IBAction)signInButtonPressed:(id)sender {
}

- (IBAction)googleButtonPressed:(id)sender {
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
}

- (IBAction)facebookButtonPressed:(id)sender {
    [self.view startLoading];
    [[FacebookLoginHelper sharedInstance] signInFBWithController:self completionHandler:^(NSString *token, NSError *error) {
        if(token.length > 0){
            [[APIManager sharedInstance] userRegisterWithFacebookToken:token completionHandler:^(BOOL success, APIResponse *obj){
                [self.view stopLoading];
                if (success) {
                    NSLog(@"USER: %@", obj.user.userName);
                    if(obj.user.userNew){
                        [self performSelector:@selector(loadReview) withObject:nil afterDelay:.5];
                    }else{
                        [self performSelector:@selector(loadFeed) withObject:nil afterDelay:.5];
                    }
                }else{
                    [self.view stopLoading];
                    if(obj.error.length > 0)
                        [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:obj.error viewController:self];
                    else
                        [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
                }
            }];
        }else{
            [self.view stopLoading];
            [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:error.localizedDescription viewController:self];
        }
    }];
}

-(void)loadReview{
    [self performSegueWithIdentifier:@"reviewSegue" sender:self];
}

-(void)loadFeed{
    [self performSegueWithIdentifier:@"feedSegue" sender:self];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.nameTextField)
        [self.emailTextField becomeFirstResponder];
    if(textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    else
        [self.passwordTextField resignFirstResponder];
    return true;
}

#pragma mark - Google Signin Delegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [self.view stopLoading];
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Google user: %@", [GoogleSignInHelper sharedInstance].fullName);
}

#pragma GoogleSignInHelperDelegate
-(void)userSignedInWithUserId:(GIDGoogleUser *)user{
    [self.view startLoading];
    [[GoogleSignInHelper sharedInstance] getUserProfilePictureWithProfile:user.profile completionhandler:^(NSURL *url, BOOL success) {
        [[APIManager sharedInstance] userRegisterWithGoogleId:user.userID email:user.profile.email name:user.profile.name userPicture:[url absoluteString] completionHandler:^(BOOL success, APIResponse *obj) {
            [self.view stopLoading];
            if (success) {
                NSLog(@"USER: %@", obj.user.userName);
                if(obj.user.userNew){
                    [self performSelector:@selector(loadReview) withObject:nil afterDelay:.5];
                }else{
                    [self performSelector:@selector(loadFeed) withObject:nil afterDelay:.5];
                }
                [self performSelector:@selector(loadReview) withObject:nil afterDelay:.5];
            }else{
                [self.view stopLoading];
                if(obj.error.length > 0)
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:obj.error viewController:self];
                else
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_register_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
            }
        }];
    }];
}

@end
