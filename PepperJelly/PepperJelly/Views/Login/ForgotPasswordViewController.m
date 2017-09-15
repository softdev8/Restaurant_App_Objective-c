//
//  ForgotPasswordViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "DesignableButton.h"
#import "UIView+Borders.h"
#import "UIColor+PepperJelly.h"
#import "UIView+Loading.h"
#import "APIManager.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet DesignableButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *sentLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTextField.text = self.email;
    
    self.sentLabel.hidden = true;
}

-(void)viewDidLayoutSubviews{
    [self.emailTextField addBorderToEdge:UIRectEdgeBottom color:[UIColor lightGreyColor] thickness:2];    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextField resignFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - Events

- (IBAction)submitButtonPressed:(id)sender {
    if(![APIManager isValidUserName:self.emailTextField.text]){
        [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_invalid_email", @"") viewController:self];
        return;
    }
    
    [self.view startLoading];
    [APIManager.sharedInstance forgotPasswordWithEmail:self.emailTextField.text completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        if(success){
            [self showMessageSent];
        }else{
            if(response.error.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_forgotpassword_title", @"") message:response.error viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_forgotpassword_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}

-(void)showMessageSent{
    self.sentLabel.hidden = false;
    self.sentLabel.alpha = 0;
    [UIView animateWithDuration:0.1f animations:^{
        self.submitButton.alpha = 0;
        self.sentLabel.alpha = 1;
    }completion:^(BOOL finished) {
        self.submitButton.hidden = true;
        [UIView animateWithDuration:0.2f animations:^{
            self.sentLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f animations:^{
                self.sentLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.emailTextField)
        [self.emailTextField resignFirstResponder];
    return true;
}


@end
