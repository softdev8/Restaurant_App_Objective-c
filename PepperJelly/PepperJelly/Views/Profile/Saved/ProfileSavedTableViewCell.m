//
//  ProfileSavedTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileSavedTableViewCell.h"

@implementation ProfileSavedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.delegate deleteSaved:self.saved];
}

@end
