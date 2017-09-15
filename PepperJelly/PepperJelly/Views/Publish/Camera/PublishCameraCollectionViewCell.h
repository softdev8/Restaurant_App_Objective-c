//
//  PublishCameraCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/14/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"
#import "PublishProtocols.h"

@interface PublishCameraCollectionViewCell : UICollectionViewCell <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) id<PublishDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet DesignableButton *cameraButton;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

-(void)configWithDelegate:(id)delegate;

@end
