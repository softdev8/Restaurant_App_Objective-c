//
//  RestaurantHeaderDetailsTimeTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantHeaderDetailsTimeTableViewCell.h"

@implementation RestaurantHeaderDetailsTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.timeLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)animateIn{
    self.timeLabel.hidden = false;
    self.timeLabel.alpha = 0;
    self.timeLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.timeLabel.alpha = 1;
            self.timeLabel.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.timeLabel.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

-(void)animateOutWithCompletion:(void (^)())completion{
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.timeLabel.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.timeLabel.alpha = 0;
                self.timeLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
            } completion:^(BOOL finished) {
                self.timeLabel.hidden = true;
                completion();
            }];
        }];
    }];
}

@end
