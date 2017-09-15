//
//  SingleHeaderTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantHeaderTableViewCell.h"

@implementation RestaurantHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)restaurantButtonPressed:(id)sender {
    [self.delegate didTapRestaurantViewsCount];
}

@end
