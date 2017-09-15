//
//  SearchRestaurantCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/17/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchProtocols.h"

@interface SearchRestaurantCollectionViewCell : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<SearchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *restaurants;
@property (strong, nonatomic) NSString *searchString;

-(void)updateWithRestaurants:(NSArray*)restaurants searchString:(NSString*)searchString;

@end
