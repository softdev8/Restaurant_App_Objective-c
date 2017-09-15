//
//  ProfileSavedTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"
#import "Restaurant.h"

@protocol ProfileSavedDelegate <NSObject>

@optional
-(void)deleteSaved:(Restaurant*)saved;

@end

@interface ProfileSavedTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ProfileSavedDelegate> delegate;
@property (strong, nonatomic) Restaurant *saved;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet DesignableButton *removeButton;

@end
