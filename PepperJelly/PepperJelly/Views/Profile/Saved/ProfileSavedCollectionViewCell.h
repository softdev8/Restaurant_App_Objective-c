//
//  ProfileSavedCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileSavedTableViewCell.h"
#import "ProfileProtocols.h"

@interface ProfileSavedCollectionViewCell : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource, ProfileSavedDelegate>

@property (weak, nonatomic) id<ProfileDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *saved;

@end
