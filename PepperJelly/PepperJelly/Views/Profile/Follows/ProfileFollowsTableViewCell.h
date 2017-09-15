//
//  ProfileFollowsTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/8/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableImageView.h"
#import "DesignableButton.h"
#import "ProfileProtocols.h"

@interface ProfileFollowsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ProfileDelegate> delegate;
@property (assign, nonatomic) BOOL following;
@property (assign, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet DesignableImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet DesignableButton *followButton;

-(void)configWithUser:(User*)user following:(BOOL)following delegate:(id)delegate;

@end
