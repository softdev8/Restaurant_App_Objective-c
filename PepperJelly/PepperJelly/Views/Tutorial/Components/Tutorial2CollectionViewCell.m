//
//  Tutorial2CollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "Tutorial2CollectionViewCell.h"

@implementation Tutorial2CollectionViewCell{
    CGPoint handOriginalCenter;
}

-(void)prepareForAnimation{
    [super prepareForAnimation];
    handOriginalCenter = self.handImageView.center;
    
    self.handImageView.translatesAutoresizingMaskIntoConstraints = true;
    self.handImageView.center = CGPointMake(self.frame.size.width, self.handImageView.center.y);
    self.handImageView.hidden = true;
}

-(void)animateIn{
    [super animateIn];
    
    self.handImageView.hidden = false;
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.handImageView.center = handOriginalCenter;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.handImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.handImageView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.pepperImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.pepperImageView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

@end
