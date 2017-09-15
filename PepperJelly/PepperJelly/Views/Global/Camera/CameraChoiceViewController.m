//
//  CameraChoiceViewController.m
//  Tribelook
//
//  Created by Evandro Harrison Hoffmann on 3/18/16.
//  Copyright © 2016 gary brook. All rights reserved.
//

#import "CameraChoiceViewController.h"

@interface CameraChoiceViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation CameraChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.contentView.hidden = true;
}

-(void)viewDidAppear:(BOOL)animated{
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
            completion();
        }];
    }];
}

#pragma mark - Actions

- (IBAction)cameraButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self dismissViewControllerAnimated:true completion:^{
            [self.delegate cameraOptionSelected:CameraOptionCamera];
        }];
    }];
}

- (IBAction)libraryButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self dismissViewControllerAnimated:true completion:^{
            [self.delegate cameraOptionSelected:CameraOptionLibrary];
        }];
    }];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self hideContentWithCompletion:^{
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}

@end
