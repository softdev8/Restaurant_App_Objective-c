//
//  LikedDescriptionTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "LikedDescriptionTableViewCell.h"

@implementation LikedDescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Events

- (IBAction)restaurantButtonPressed:(id)sender {
    [self.delegate openRestaurant];
}
@end
