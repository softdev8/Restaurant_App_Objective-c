//
//  UIButton+Online.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Online)

-(void)setImageWithUrl:(NSString *)url placeHolder:(UIImage*)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *image))completion;
-(void)setImageWithUrl:(NSString *)url thumbnail:(NSString*)thumbnail placeHolder:(UIImage*)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *image))completion;

-(void)setBackgroundImageWithUrl:(NSString *)url placeHolder:(UIImage*)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *image))completion;
-(void)setBackgroundImageWithUrl:(NSString *)url thumbnail:(NSString*)thumbnail placeHolder:(UIImage*)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *image))completion;

@end
