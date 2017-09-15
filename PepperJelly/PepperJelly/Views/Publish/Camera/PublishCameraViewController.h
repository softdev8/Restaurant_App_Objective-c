//
//  PublishCameraViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 6/16/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishProtocols.h"

@interface PublishCameraViewController : UIViewController

@property (weak, nonatomic) id<PublishDelegate> delegate;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end
