//
//  UIImageView+Online.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/19/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Online)

-(void)setImageWithUrl:(NSString *)url placeHolder:(UIImage*)placeholder completion:(void (^)(UIImage *image))completion;
-(void)setImageWithUrl:(NSString *)url thumbnail:(NSString *)thumbnail placeHolder:(UIImage *)placeholder completion:(void (^)(UIImage *))completion;
-(void)setImage:(UIImage*)image animated:(BOOL)animated;

@end
