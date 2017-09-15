//
//  PublishCameraCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/14/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PublishCameraCollectionViewCell.h"

@implementation PublishCameraCollectionViewCell

-(void)configWithDelegate:(id)delegate{
    self.delegate = delegate;
    [self setupCameraView];
}

-(void)setupCameraView {
    if(self.imagePickerController)
        [self.imagePickerController.view removeFromSuperview];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.imagePickerController.preferredContentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
#if TARGET_IPHONE_SIMULATOR
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.showsCameraControls = true;
#endif
    self.imagePickerController.delegate = self;
    //self.imagePickerController.allowsEditing = YES;
    
    [self addSubview:self.imagePickerController.view];
}

#pragma mark - Events

- (IBAction)cameraButtonPressed:(id)sender {
    [self.imagePickerController takePicture];
}

#pragma mark - ImagePicker delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.delegate canceledFromCamera];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* originalImage = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    [self.delegate selectImageFromCamera:originalImage];
}


@end
