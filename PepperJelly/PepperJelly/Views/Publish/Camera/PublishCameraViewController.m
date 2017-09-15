//
//  PublishCameraViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 6/16/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PublishCameraViewController.h"

@interface PublishCameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@end

@implementation PublishCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidLayoutSubviews{
    
    [self setupCameraView];
}

-(BOOL)prefersStatusBarHidden{
    return true;
}

-(void)setupCameraView {
    if(self.imagePickerController)
        [self.imagePickerController.view removeFromSuperview];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.buttonView.frame.size.height);
    self.imagePickerController.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-self.buttonView.frame.size.height);
    
#if TARGET_IPHONE_SIMULATOR
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.showsCameraControls = true;
#endif
    self.imagePickerController.delegate = self;
    //self.imagePickerController.allowsEditing = YES;
    
    [self.view addSubview:self.imagePickerController.view];
}

#pragma mark - Events

- (IBAction)libraryButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)takePhotoButtonPressed:(id)sender {
}

#pragma mark - ImagePicker delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:nil];
    [self.delegate canceledFromCamera];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* originalImage = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:true completion:nil];
    [self.delegate selectImageFromCamera:originalImage];
}

@end
