//
//  LoginViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+AttributedString.h"
#import "UIColor+PepperJelly.h"
#import "UIView+Borders.h"
#import "ForgotPasswordViewController.h"
#import "SignUpViewController.h"
#import "APIManager.h"
#import "UIView+Loading.h"
#import "GoogleSignInHelper.h"
#import "FacebookLoginHelper.h"
#import <Google/SignIn.h>


@interface LoginViewController () <UITextFieldDelegate, GIDSignInUIDelegate, GoogleSignHelperDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialMediaLabel;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signUpButton setAttributedTitle:[NSString attributedStringWith: [[NSArray alloc] initWithObjects:
                                                                           [[AttributedText alloc] initWithText:NSLocalizedString(@"login_noaccount_1", @"") andAttribute:@{NSForegroundColorAttributeName:[UIColor greyishBrownColor]}],
                                                                           [[AttributedText alloc] initWithText:NSLocalizedString(@"login_noaccount_2", @"") andAttribute:@{NSForegroundColorAttributeName:[UIColor pepperjellyPinkColor]}],
                                                                           nil]] forState:UIControlStateNormal];
    
    [GoogleSignInHelper sharedInstance].delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if([UserDefaults.sharedInstance isLoggedIn]){
//        [self performSegueWithIdentifier:@"feedSegue" sender:self];
//    }
}

-(void)viewDidLayoutSubviews{
    [self.emailTextField addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
    [self.passwordTextField addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[SignUpViewController class]]){
        ((SignUpViewController*)segue.destinationViewController).email = self.emailTextField.text;
    }else if([segue.destinationViewController isKindOfClass:[ForgotPasswordViewController class]]){
        ((ForgotPasswordViewController*)segue.destinationViewController).email = self.emailTextField.text;
    }
}

-(IBAction)unwindToLogin:(UIStoryboardSegue*)sender{
}

#pragma mark - Events

- (IBAction)forgotPasswordButtonPressed:(id)sender {
}

- (IBAction)signInButtonPressed:(id)sender {
    if(![APIManager isValidUserName:self.emailTextField.text]){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_username", @"") viewController:self];
        return;
    }
    if(![APIManager isValidPassword:self.passwordTextField.text]){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_password", @"") viewController:self];
        return;
    }
    
    [self signInWithUserName:self.emailTextField.text password:self.passwordTextField.text];
}

-(void)signInWithUserName:(NSString*)userName password:(NSString*)password{
    [self.view startLoading];
    [APIManager.sharedInstance loginWithEmail:userName password:password completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        if(success){
            [self performSegueWithIdentifier:@"feedSegue" sender:self];
        }else{
            if(response.error.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_login_title", @"") message:response.error viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_login_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}

- (IBAction)signUpButtonPressed:(id)sender {
}

- (IBAction)googleButtonPressed:(id)sender {
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
}

-(void)loadFeed{
    [self performSegueWithIdentifier:@"feedSegue" sender:self];
}

-(void)loadReview{
    [self performSegueWithIdentifier:@"reviewSegue" sender:self];
}

- (IBAction)facebookButtonPressed:(id)sender {
    [self.view startLoading];
    [[FacebookLoginHelper sharedInstance] signInFBWithController:self completionHandler:^(NSString *token, NSError *error) {
        if(token.length > 0){
            [[APIManager sharedInstance] userRegisterWithFacebookToken:token completionHandler:^(BOOL success, APIResponse *obj){
                [self.view stopLoading];
                if (success) {
                    NSLog(@"USER: %@", obj.user.userNew);
                    if(obj.user.userNew){
                        [self performSelector:@selector(loadReview) withObject:nil afterDelay:.5];
                    }else{
                        [self performSelector:@selector(loadFeed) withObject:nil afterDelay:.5];
                    }
                }else{
                    [self.view stopLoading];
                    if(obj.error.length > 0)
                        [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_login_title", @"") message:obj.error viewController:self];
                    else
                        [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_login_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
                }
            }];
        }else{
            [self.view stopLoading];
            [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_login_title", @"") message:error.localizedDescription viewController:self];
        }
    }];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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
                NSLog(@"USER: %@", obj.user.userName);
                if(obj.user.userNew){
                    [self performSelector:@selector(loadReview) withObject:nil afterDelay:.5];
                }else{
                    [self performSelector:@selector(loadFeed) withObject:nil afterDelay:.5];
                }
            }else{
                [self.view stopLoading];
                if(obj.error.length > 0)
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_login_title", @"") message:obj.error viewController:self];
                else
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_login_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
            }
        }];
    }];
}
@end
