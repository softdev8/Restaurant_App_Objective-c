//
//  UIButton+Online.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UIButton+Online.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"

@implementation UIButton (Online)

-(void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *))completion{
    [self startLoading];
    [self setImage:placeholder forState:state];
    [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
        [self stopLoading];
        [self setImage:image forState:state];
    }];
}

-(void)setImageWithUrl:(NSString *)url thumbnail:(NSString *)thumbnail placeHolder:(UIImage *)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *))completion{
    [self startLoading];
    [self setImage:placeholder forState:state];
    [UIImage imageWithUrl:thumbnail placeHolder:placeholder completion:^(UIImage *image) {
        [self setImage:image forState:state];
        
        [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
            [self stopLoading];
            [self setImage:image forState:state];
        }];
    }];
}

-(void)setBackgroundImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *))completion{
    [self startLoading];
    [self setBackgroundImage:placeholder forState:state];
    [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
        [self stopLoading];
        [self setBackgroundImage:image forState:state];
    }];
}

-(void)setBackgroundImageWithUrl:(NSString *)url thumbnail:(NSString *)thumbnail placeHolder:(UIImage *)placeholder forState:(UIControlState)state completion:(void (^)(UIImage *))completion{
    [self startLoading];
    [self setBackgroundImage:placeholder forState:state];
    [UIImage imageWithUrl:thumbnail placeHolder:placeholder completion:^(UIImage *image) {
        [self setBackgroundImage:image forState:state];
        
        [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
            [self stopLoading];
            [self setBackgroundImage:image forState:state];
        }];
    }];
}

@end
