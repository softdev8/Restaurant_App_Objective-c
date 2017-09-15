//
//  PublishConfirmationViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PublishConfirmationViewController.h"
#import "DesignableButton.h"
#import "APIManager.h"
@import Photos;
@import MBProgressHUD;

@interface PublishConfirmationViewController (){
    CGPoint corkInitialCenter;
    CGPoint corkBurstInitialCenter;
    CGPoint star1InitialCenter;
    CGPoint star2InitialCenter;
}

@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIImageView *corkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *corkBurstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starsImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stars2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet DesignableButton *okButton;
@property (weak, nonatomic) IBOutlet DesignableButton *postAnotherButton;

@end

@implementation PublishConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = true;
    self.corkImageView.hidden = true;
    self.corkBurstImageView.hidden = true;
    self.starsImageView.hidden = true;
    self.stars2ImageView.hidden = true;
    self.bottleImageView.hidden = true;
}

-(void)viewDidLayoutSubviews{
    corkInitialCenter = self.corkImageView.center;
    corkBurstInitialCenter = self.corkBurstImageView.center;
    star1InitialCenter = self.starsImageView.center;
    star2InitialCenter = self.stars2ImageView.center;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self prepareForAnimation];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self animateIn];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - Events

- (IBAction)okButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)postAnotherButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)postToInstagramPressed:(id)sender {
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:self.publishedImage];
        } completionHandler:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            if (success) {
                NSLog(@"Save photo to photos library success");
                PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
                fetchOptions.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
                PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
                if ([fetchResult firstObject]) {
                    PHAsset *asset = [fetchResult firstObject];
                    NSString *escapedCaption = [@"More deliciousness on @pepperjelly" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString *urlString = [NSString stringWithFormat:@"instagram://library?LocalIdentifier=%@&InstagramCaption=%@", asset.localIdentifier, escapedCaption];
                    NSURL *instagramURL = [NSURL URLWithString:urlString];
                    [[UIApplication sharedApplication] openURL:instagramURL];
                }
            } else {
                [APIManager showAlertWithTitle:@"Oops!" message:@"Something went wrong. Please try again." viewController:self];
            }
        }];
    } else {
        [APIManager showAlertWithTitle:@"Oops!" message:@"You don't have instagram installed." viewController:self];
    }
}

#pragma mark - Animations

- (void)prepareForAnimation{
    
    self.corkImageView.center = corkInitialCenter;
    self.corkBurstImageView.center = corkBurstInitialCenter;
    self.starsImageView.center = star1InitialCenter;
    self.stars2ImageView.center = star2InitialCenter;
}

- (void)animateIn{
    self.corkImageView.hidden = false;
    self.corkImageView.alpha = 0;
    self.corkImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    self.bottleImageView.hidden = false;
    self.bottleImageView.alpha = 0;
    self.bottleImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    //show bottle
    [UIView animateWithDuration:0.3f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.corkImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.corkImageView.alpha = 1;
        
        self.bottleImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.bottleImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.corkImageView.transform = CGAffineTransformMakeScale(1, 1);
            self.bottleImageView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            //shake
            [UIView animateWithDuration:0.1f animations:^{
                self.corkImageView.transform = CGAffineTransformMakeRotation(0.1);
                self.bottleImageView.transform = CGAffineTransformMakeRotation(0.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f animations:^{
                    self.corkImageView.transform = CGAffineTransformMakeRotation(-0.1);
                    self.bottleImageView.transform = CGAffineTransformMakeRotation(-0.1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1f animations:^{
                        self.corkImageView.transform = CGAffineTransformMakeRotation(0);
                        self.bottleImageView.transform = CGAffineTransformMakeRotation(0);
                    } completion:^(BOOL finished) {
                        
                        //burst
                        self.corkBurstImageView.center = self.corkImageView.center;
                        self.corkBurstImageView.hidden = false;
                        self.corkBurstImageView.alpha = 0;
                        self.corkBurstImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                        
                        self.starsImageView.center = self.bottleImageView.center;
                        self.starsImageView.hidden = false;
                        self.starsImageView.alpha = 0;
                        self.starsImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                        
                        self.stars2ImageView.center = self.bottleImageView.center;
                        self.stars2ImageView.hidden = false;
                        self.stars2ImageView.alpha = 0;
                        self.stars2ImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                        
                        [UIView animateWithDuration:0.2f animations:^{
                            self.corkImageView.center = CGPointMake(corkBurstInitialCenter.x*0.8f, self.corkImageView.frame.size.height/2);
                            
                            self.corkBurstImageView.alpha = 1;
                            self.corkBurstImageView.transform = CGAffineTransformMakeScale(1, 1);
                            self.corkBurstImageView.center = corkBurstInitialCenter;
                            
                            self.starsImageView.alpha = 1;
                            self.starsImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                            self.starsImageView.center = star1InitialCenter;
                            
                            self.stars2ImageView.alpha = 1;
                            self.stars2ImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                            self.stars2ImageView.center = star2InitialCenter;
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.1f animations:^{
                                self.starsImageView.transform = CGAffineTransformMakeScale(1, 1);
                                self.stars2ImageView.transform = CGAffineTransformMakeScale(1, 1);
                            } completion:^(BOOL finished) {
                                
                            }];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

@end
