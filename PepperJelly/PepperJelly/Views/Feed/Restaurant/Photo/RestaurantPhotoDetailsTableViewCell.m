//
//  RestaurantPhotoDetailsTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantPhotoDetailsTableViewCell.h"

@implementation RestaurantPhotoDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Events

- (IBAction)closeButtonPressed:(id)sender {
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.center = CGPointMake(self.center.x, self.center.y+20);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y-20, self.frame.size.width, 0);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self.delegate showPhotoDetails:false];
        }];
    }];
}

@end
