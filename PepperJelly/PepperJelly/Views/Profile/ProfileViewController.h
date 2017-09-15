//
//  ProfileViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileProtocols.h"
#import "DesignableImageView.h"
#import "ProfileFollowsTableView.h"
#import "ProfileUploadCollectionViewCell.h"
#import "ProfileSavedCollectionViewCell.h"
#import "ProfileLikeCollectionViewCell.h"

@interface ProfileViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, ProfileDelegate> {
    BOOL firstTime;
    CGPoint startDragOffset;
    BOOL sameAsLastChangeFollowers;
}

@property (weak, nonatomic) IBOutlet DesignableImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *configButton;
@property (weak, nonatomic) IBOutlet UIButton *followersCountButton;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingCountButton;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UIButton *savedButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadsButton;
@property (weak, nonatomic) IBOutlet UIButton *likedPhotosButton;
@property (weak, nonatomic) IBOutlet UIView *selectedButtonView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet ProfileFollowsTableView *followsTableView;
@property (weak, nonatomic) IBOutlet UILabel *userBioLabel;



@property (strong, nonatomic) NSMutableArray *followerUsers;
@property (strong, nonatomic) NSMutableArray *followingUsers;

- (void)syncronize;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)followersButtonPressed:(id)sender;
- (IBAction)followingButtonPressed:(id)sender;
- (void)toggleFollowing;
- (IBAction)configButtonPressed:(id)sender;
- (IBAction)savedButtonPressed:(id)sender;
- (IBAction)uploadsButtonPressed:(id)sender;
- (IBAction)likedPhotosButtonPressed:(id)sender;
- (void)updateTabSelectionWithButton:(UIButton*)button;
- (void)updateFollowers;
- (void)updateFollowing;

@end
