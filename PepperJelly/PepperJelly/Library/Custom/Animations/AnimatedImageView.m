//
//  AnimatedImageView.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/1/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "AnimatedImageView.h"

@implementation AnimatedImageView

-(void)setAlphaAnimationWithTime:(float)time delay:(float)delay option:(int)option force:(float)force{
    self.alphaAnimation = true;
    self.animationTime = time;
    self.animationDelay = delay;
    self.animationOption = option;
    self.animationForce = force;
    
    self.alpha = 0;
}

-(void)setAlphaAnimationWithTime:(float)time timeSpan:(float)timeSpan delay:(float)delay delaySpan:(float)delaySpan option:(int)option force:(float)force forceSpan:(float)forceSpan{
    self.alphaAnimation = true;
    self.animationTime = [self randomValueBetween:time-timeSpan andB:time+timeSpan];
    self.animationDelay = [self randomValueBetween:delay-delaySpan andB:delay+delaySpan];
    self.animationOption = option;
    self.animationForce = [self randomValueBetween:force-forceSpan andB:force+forceSpan];
    
    self.alpha = 0;
}

-(void)startAnimation{
    if(self.alphaAnimation){
        [UIView animateWithDuration:self.animationTime delay:self.animationDelay options:self.animationOption animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if(self.animationForce != 0){
        [UIView animateWithDuration:self.animationTime*0.7 delay:self.animationDelay options:self.animationOption animations:^{
            self.transform = CGAffineTransformMakeScale(1+self.animationForce, 1+self.animationForce);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.animationTime*0.3 delay:self.animationDelay options:self.animationOption animations:^{
                self.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

-(float)randomValueBetween:(float)a andB:(float)b{
    return (((float)arc4random()) / 0xFFFFFFFFu)*((float)(b - a)) + a;
}

@end
