//
//  SearchUserCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/17/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProtocols.h"
#import "ProfileProtocols.h"

@interface SearchUserCollectionViewCell : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource, ProfileDelegate>

@property (weak, nonatomic) id<SearchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSString *searchString;

-(void)updateWithUsers:(NSArray*)users searchString:(NSString*)searchString;

@end
