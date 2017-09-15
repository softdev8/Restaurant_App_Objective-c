//
//  ImageCropViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/16/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCropDelegate <NSObject>

-(void)finishedCroppingImage:(UIImage*)image;

@end

@interface ImageCropViewController : UIViewController

@property (nonatomic, weak) id<ImageCropDelegate> delegate;

@property (nonatomic, strong) UIImage *image;

@end
