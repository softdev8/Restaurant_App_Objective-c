//
//  FeedTutorialViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantTutorialViewController.h"
#import "DesignableButton.h"
#import "DesignableView.h"
#import "UIColor+PepperJelly.h"
#import "Constants.h"

@interface RestaurantTutorialViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pepperLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet DesignableButton *gotItButton;
@property (weak, nonatomic) IBOutlet DesignableButton *likeButton;
@property (weak, nonatomic) IBOutlet DesignableView *trackView;

@end

@implementation RestaurantTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrowImageView.alpha = 0;
    self.handImageView.alpha = 0;
}

-(void)viewDidLayoutSubviews{
    self.view.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBA(255, 255, 255, 0.3) CGColor], (id)[RGBA(255, 255, 255, 0.9) CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self animateIn];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - Events

- (IBAction)gotItButtonPressed:(id)sender {
    if(SYSTEM_VERSION_LESS_THAN(@"9"))
        [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Animations

-(void)animateIn{
    self.arrowImageView.center = CGPointMake(self.view.frame.size.width-self.arrowImageView.frame.size.width, self.arrowImageView.center.y);
    self.handImageView.center = CGPointMake(self.view.frame.size.width-self.handImageView.frame.size.width, self.handImageView.center.y);
    
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.arrowImageView.alpha = 1;
        self.handImageView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.8f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.arrowImageView.center = CGPointMake(self.view.frame.size.width/2, self.arrowImageView.center.y);
        self.handImageView.center = CGPointMake(self.view.frame.size.width/2, self.handImageView.center.y);
    } completion:^(BOOL finished) {
        
    }];
}

@end
