//
//  UIImage+Cropping.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/16/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cropping)

+ (UIImage *) imageWithView:(UIView *)view;
+ (UIImage *) imageWithView:(UIView *)view bounds:(CGRect)bounds;

+ (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
