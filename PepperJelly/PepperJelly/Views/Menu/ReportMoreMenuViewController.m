//
//  ReportMoreMenuViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ReportMoreMenuViewController.h"
#import "PJActivityItemProvider.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"
#import "User.h"
#import "APIManager.h"

@interface ReportMoreMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *inappropriateButton;
@property (weak, nonatomic) IBOutlet UIButton *spamButton;
@property (weak, nonatomic) IBOutlet UIButton *blurryButton;

@property (weak, nonatomic) IBOutlet UIButton *userReason1Button;
@property (weak, nonatomic) IBOutlet UIButton *userReason2Button;
@property (weak, nonatomic) IBOutlet UIButton *userReason3Button;


@end

@implementation ReportMoreMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Events

- (IBAction)inappropriateButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self.reportDelegate reportDishWithDishId:self.dish.dishId andWithReason:NSLocalizedString(@"report_reason_photo_inappropriate", @"")];
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

- (IBAction)spamButtomPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self.reportDelegate reportDishWithDishId:self.dish.dishId andWithReason:NSLocalizedString(@"report_reason_photo_spam", @"")];
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

- (IBAction)blurryButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self.reportDelegate reportDishWithDishId:self.dish.dishId andWithReason:NSLocalizedString(@"report_reason_photo_low_quality", @"")];
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

- (IBAction)userReason1ButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self.reportDelegate reportUserWithUserId:self.user.userId andWithReason:NSLocalizedString(@"report_reason_profile_inappropriate", @"")];
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

- (IBAction)userReason2ButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self.reportDelegate reportUserWithUserId:self.user.userId andWithReason:NSLocalizedString(@"report_reason_profile_spam", @"")];
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

- (IBAction)userReason3ButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self.reportDelegate reportUserWithUserId:self.user.userId andWithReason:NSLocalizedString(@"report_reason_profile_violates", @"")];
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self.reportDelegate reportCanceled];
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }];
}

@end
