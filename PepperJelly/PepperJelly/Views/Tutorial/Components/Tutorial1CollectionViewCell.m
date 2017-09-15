//
//  Tutorial1CollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "Tutorial1CollectionViewCell.h"

@implementation Tutorial1CollectionViewCell{
    CGPoint forkOriginalCenter;
    CGRect pastaVerticalOriginalFrame;
}

-(void)prepareForAnimation{
    [super prepareForAnimation];
    
    forkOriginalCenter = self.forkImageView.center;
    pastaVerticalOriginalFrame = self.pastaVerticalImageView.frame;
    
    self.animationView.translatesAutoresizingMaskIntoConstraints = true;
    self.animationView.center = CGPointMake(30, self.animationView.center.y);
    self.animationView.transform = CGAffineTransformMakeRotation(0.5);
    
    self.pastaRoll1ImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    self.pastaRoll2ImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    self.forkImageView.translatesAutoresizingMaskIntoConstraints = true;
    self.forkImageView.center = CGPointMake(-200, self.forkImageView.center.y);
    self.forkImageView.transform = CGAffineTransformMakeRotation(0.2);
    self.forkImageView.hidden = true;
    
    self.pastaVerticalImageView.translatesAutoresizingMaskIntoConstraints = true;
    self.pastaVerticalImageView.frame = CGRectMake(self.pastaVerticalImageView.frame.origin.x, self.pastaVerticalImageView.frame.origin.y+self.pastaVerticalImageView.frame.size.height, self.pastaVerticalImageView.frame.size.width, 0);
    self.pastaVerticalImageView.hidden = true;
}

-(void)animateIn{
    [super animateIn];
    
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.animationView.center = animationViewOriginalCenter;
        self.animationView.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        self.forkImageView.hidden = false;
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.forkImageView.center = CGPointMake(forkOriginalCenter.x, self.bowlImageView.frame.origin.y);
        } completion:^(BOOL finished) {
            self.pastaVerticalImageView.hidden = false;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.forkImageView.center = forkOriginalCenter;
                self.forkImageView.transform = CGAffineTransformMakeRotation(0);
                self.pastaVerticalImageView.frame = pastaVerticalOriginalFrame;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
    
    [UIView animateWithDuration:2 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.pastaRoll1ImageView.transform = CGAffineTransformMakeScale(1, 1);
        self.pastaRoll2ImageView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

@end
