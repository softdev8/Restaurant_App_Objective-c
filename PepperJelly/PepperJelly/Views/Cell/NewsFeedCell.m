//
//  NewsFeedCell.m
//  PepperJelly
//
//  Created by Sean McCue on 7/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "NewsFeedCell.h"
#import "UIColor+PepperJelly.h"
#import "NSDate+Custom.h"
@import NSDate_TimeAgo;

@implementation NewsFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configireView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configireView{
    self.profileImgBtn.layer.cornerRadius = self.profileImgBtn.frame.size.height /2;
    self.profileImgBtn.layer.masksToBounds = true;
}

-(void)setTimeStamp:(NSString *)dateStr{
    NSDate *date = [NSDate stringToDate:dateStr format:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
    self.timeStampLbl.text = [date timeAgo];
}

-(void)updateFollowButton:(BOOL)following{
        if(following){
            self.followingButton.borderColor = [UIColor lightGrayColor];
            self.followingButton.borderWidth = 2;
            self.followingButton.backgroundColor = [UIColor whiteColor];
            [self.followingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.followingButton setTitle:NSLocalizedString(@"unfollow", @"") forState:UIControlStateNormal];
        }else{
            self.followingButton.borderColor = [UIColor clearColor];
            self.followingButton.borderWidth = 0;
            self.followingButton.backgroundColor = [UIColor followOrange];
            [self.followingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.followingButton setTitle:NSLocalizedString(@"follow", @"") forState:UIControlStateNormal];
        }
}

#pragma mark - Events
- (IBAction)profileImgBtnTapped:(id)sender {
    [self.delegate userPressedProfileImgBtn:self.tag];
}

- (IBAction)dishImageBtnTapped:(id)sender {
    [self.delegate userPressedDishImgBtn:self.tag];
}

- (IBAction)followButtonPressed:(id)sender {
    if([self.followingButton.titleLabel.text isEqualToString:NSLocalizedString(@"unfollow", @"")]){
        [self.delegate unFollowWithCellTag:self.tag];
    }else{
        [self.delegate followWithCelltag:self.tag];
    }
}




@end
