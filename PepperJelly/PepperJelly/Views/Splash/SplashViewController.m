//
//  SplashViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "SplashViewController.h"
#import "UIColor+PepperJelly.h"
#import "AnimatedImageView.h"
#import "APIManager.h"

#define splashScreenTime 3
#define logoAnimationTime 0.5f
#define logoAnimationForce 0.2f
#define iconsAnimationTime 0.5f
#define iconsAnimationTimeSpan 0.5f
#define iconsDelayTime 0.7f
#define iconsDelayTimeSpan 0.5f
#define iconsForce 0.1f
#define iconsForceSpan 0.05f
#define iconsAnimationOption UIViewAnimationOptionCurveEaseIn

@interface SplashViewController ()

@property (weak, nonatomic) IBOutlet AnimatedImageView *logo;
@property (weak, nonatomic) IBOutlet AnimatedImageView *logoText;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon1_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon1_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon1_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon1_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon1_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon2_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon2_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon2_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon2_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon2_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon3_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon3_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon3_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon3_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon3_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon4_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon4_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon4_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon4_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon4_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon5_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon5_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon5_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon5_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon5_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon6_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon6_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon6_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon6_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon7_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon7_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon8_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon8_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon8_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon8_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon8_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon9_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon9_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon9_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon9_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon9_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon10_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon10_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon10_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon10_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon10_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon11_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon11_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon11_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon11_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon11_5;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon12_1;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon12_2;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon12_3;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon12_4;
@property (weak, nonatomic) IBOutlet AnimatedImageView *icon12_5;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whitesmokeBackgroundColor];
    
    [self prepareForAnimation];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self animateIn];
}

#pragma mark - Animations

-(void)prepareForAnimation{
    [self.logo setAlphaAnimationWithTime:logoAnimationTime delay:0 option:iconsAnimationOption force:logoAnimationForce];
    [self.logoText setAlphaAnimationWithTime:logoAnimationTime delay:0 option:iconsAnimationOption force:logoAnimationForce];
    [self.icon1_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon1_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon1_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon1_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon1_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon2_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon2_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon2_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon2_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon2_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon3_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon3_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon3_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon3_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon3_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon4_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon4_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon4_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon4_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon4_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon5_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon5_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon5_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon5_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon5_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon6_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon6_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon6_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon6_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon7_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon7_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon8_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon8_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon8_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon8_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon8_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon9_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon9_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon9_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon9_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon9_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon10_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon10_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon10_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon10_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon10_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon11_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon11_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon11_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon11_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon11_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon12_1 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon12_2 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon12_3 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon12_4 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
    [self.icon12_5 setAlphaAnimationWithTime:iconsAnimationTime timeSpan:iconsAnimationTimeSpan delay:iconsDelayTime delaySpan:iconsDelayTimeSpan option:iconsAnimationOption force:iconsForce forceSpan:iconsForceSpan];
}

- (void)animateIn{
    [self.logo startAnimation];
    [self.logoText startAnimation];
    [self.icon1_1 startAnimation];
    [self.icon1_2 startAnimation];
    [self.icon1_3 startAnimation];
    [self.icon1_4 startAnimation];
    [self.icon1_5 startAnimation];
    [self.icon2_1 startAnimation];
    [self.icon2_2 startAnimation];
    [self.icon2_3 startAnimation];
    [self.icon2_4 startAnimation];
    [self.icon2_5 startAnimation];
    [self.icon3_1 startAnimation];
    [self.icon3_2 startAnimation];
    [self.icon3_3 startAnimation];
    [self.icon3_4 startAnimation];
    [self.icon3_5 startAnimation];
    [self.icon4_1 startAnimation];
    [self.icon4_2 startAnimation];
    [self.icon4_3 startAnimation];
    [self.icon4_4 startAnimation];
    [self.icon4_5 startAnimation];
    [self.icon5_1 startAnimation];
    [self.icon5_2 startAnimation];
    [self.icon5_3 startAnimation];
    [self.icon5_4 startAnimation];
    [self.icon5_5 startAnimation];
    [self.icon6_1 startAnimation];
    [self.icon6_2 startAnimation];
    [self.icon6_4 startAnimation];
    [self.icon6_5 startAnimation];
    [self.icon7_1 startAnimation];
    [self.icon7_5 startAnimation];
    [self.icon8_1 startAnimation];
    [self.icon8_2 startAnimation];
    [self.icon8_3 startAnimation];
    [self.icon8_4 startAnimation];
    [self.icon8_5 startAnimation];
    [self.icon9_1 startAnimation];
    [self.icon9_2 startAnimation];
    [self.icon9_3 startAnimation];
    [self.icon9_4 startAnimation];
    [self.icon9_5 startAnimation];
    [self.icon10_1 startAnimation];
    [self.icon10_2 startAnimation];
    [self.icon10_3 startAnimation];
    [self.icon10_4 startAnimation];
    [self.icon10_5 startAnimation];
    [self.icon11_1 startAnimation];
    [self.icon11_2 startAnimation];
    [self.icon11_3 startAnimation];
    [self.icon11_4 startAnimation];
    [self.icon11_5 startAnimation];
    [self.icon12_1 startAnimation];
    [self.icon12_2 startAnimation];
    [self.icon12_3 startAnimation];
    [self.icon12_4 startAnimation];
    [self.icon12_5 startAnimation];
    
    [NSTimer scheduledTimerWithTimeInterval:splashScreenTime target:self selector:@selector(proceedToLogin) userInfo:nil repeats:NO];
}

-(void)proceedToLogin{
    if([APIManager.sharedInstance isLoggedIn])
        [self performSegueWithIdentifier:@"feedSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

#pragma mark - Navigation

-(IBAction)unwindToSplash:(UIStoryboardSegue*)sender{
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(proceedToLogin) userInfo:nil repeats:NO];
}

@end
