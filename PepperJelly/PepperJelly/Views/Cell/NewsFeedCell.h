//
//  NewsFeedCell.h
//  PepperJelly
//
//  Created by Sean McCue on 7/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"

@protocol NewsFeedDelegate <NSObject>

@optional
-(void)followWithCelltag:(NSInteger)tag;
-(void)unFollowWithCellTag:(NSInteger)tag;
-(void)userPressedProfileImgBtn:(NSInteger)tag;
-(void)userPressedDishImgBtn:(NSInteger)tag;
@end

@interface NewsFeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet DesignableButton *followingButton;
@property (weak, nonatomic) IBOutlet UIImageView *dishImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLbl;
@property (weak, nonatomic) id<NewsFeedDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *profileImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *dishImgBtn;

-(void)updateFollowButton:(BOOL)following;
-(void)setTimeStamp:(NSString *)dateStr;

@end
