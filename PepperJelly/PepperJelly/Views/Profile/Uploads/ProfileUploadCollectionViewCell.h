//
//  ProfileCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileProtocols.h"
#import "User.h"

@interface ProfileUploadCollectionViewCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource>{
    BOOL isPaging;
}

@property (weak, nonatomic) id<ProfileDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *publishButton;

@property (strong, nonatomic) NSMutableArray *feeds;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL canLoadMore;
@property (strong, nonatomic) User *user;

-(void)syncronize;

@end
