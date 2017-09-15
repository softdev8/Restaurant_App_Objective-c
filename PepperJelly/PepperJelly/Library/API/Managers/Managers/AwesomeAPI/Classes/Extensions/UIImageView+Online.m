//
//  UIImageView+Online.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/19/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UIImageView+Online.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"

@implementation UIImageView (Online)

-(void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeholder completion:(void (^)(UIImage *))completion{
    
    //return;
    
    self.layer.masksToBounds = true;
    
    [self startLoading];
    self.image = placeholder;
    
    
    
    [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
        [self stopLoading];
        self.image = image;
    }];
}

-(void)setImageWithUrl:(NSString *)url thumbnail:(NSString *)thumbnail placeHolder:(UIImage *)placeholder completion:(void (^)(UIImage *))completion{
    
    return;
    
    self.layer.masksToBounds = true;
    
    [self startLoading];
    self.image = placeholder;
    [UIImage imageWithUrl:thumbnail placeHolder:placeholder completion:^(UIImage *image) {
        self.image = image;
        
        [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
            [self stopLoading];
            self.image = image;
        }];
    }];
}

-(void)setImage:(UIImage*)image animated:(BOOL)animated{
    
    return;
    
    if(animated){
        self.image = image;
        if(self.image == nil){
            self.alpha = 0;
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    }else{
        self.image = image;
    }
}

@end
