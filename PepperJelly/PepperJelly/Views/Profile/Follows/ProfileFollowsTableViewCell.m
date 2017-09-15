//
//  ProfileFollowsTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/8/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileFollowsTableViewCell.h"
#import "User.h"

@implementation ProfileFollowsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithUser:(User *)user following:(BOOL)following delegate:(id)delegate{
    self.user = user;
    self.following = following;
    self.delegate = delegate;
    
    self.titleLabel.text = self.user.userName;
    if(self.titleLabel.text.length == 0)
        self.titleLabel.text = self.user.email;
}

#pragma mark - Events

- (IBAction)followButtonPressed:(id)sender {
    if(self.following)
       [self.delegate unfollowUser:self.user];
    else
        [self.delegate followUser:self.user];
}

@end
