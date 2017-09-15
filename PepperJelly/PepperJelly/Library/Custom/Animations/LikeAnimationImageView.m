//
//  LikeAnimationImageView.m
//  PepperJelly
//
//  Created by Sean McCue on 6/2/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "LikeAnimationImageView.h"
#import "Constants.h"

@implementation LikeAnimationImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.image = PJ_IMAGE_LIKE_ANIMATION;
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self animateLike];
    }
    return self;
}

-(void)animateLike{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
               [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                   self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                   self.alpha = 0.0;
               } completion:^(BOOL finished) {
                   self.transform = CGAffineTransformMakeScale(1.0, 1.0);
               }];
        }];
    }];
}


@end
