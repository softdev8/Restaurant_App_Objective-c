//
//  RestaurantHeaderDetailsSaveTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantHeaderDetailsSaveTableViewCell.h"

@implementation RestaurantHeaderDetailsSaveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Events

- (IBAction)saveButtonPressed:(id)sender {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.saveButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            self.saveButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.saveButton.alpha = 0;
        } completion:^(BOOL finished) {
            [self.delegate saveRestaurant];
        }];
    }];
}

@end
