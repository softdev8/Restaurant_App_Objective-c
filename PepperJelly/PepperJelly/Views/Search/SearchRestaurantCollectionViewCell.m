//
//  SearchRestaurantCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/17/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "SearchRestaurantCollectionViewCell.h"
#import "ProfileSavedTableViewCell.h"
#import "UIView+Loading.h"
#import "Restaurant.h"
#import "CDHelper.h"

@implementation SearchRestaurantCollectionViewCell

-(void)awakeFromNib{
    
    //enable to scrolltotop when tap on statusbar
    self.tableView.scrollsToTop = true;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.restaurants = [[NSMutableArray alloc] init];
}

-(void)updateWithRestaurants:(NSArray *)restaurants searchString:(NSString*)searchString{
    self.searchString = searchString;
    
    [self.restaurants removeAllObjects];
    [self.restaurants addObjectsFromArray:restaurants];
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.restaurants.count == 0 && self.searchString.length > 0)
        [self showMessageWithText:NSLocalizedString(@"empty_search_restaurants", @"")];
    else
        [self hideMessage];
    
    return self.restaurants.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileSavedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"saved" forIndexPath:indexPath];
    cell.saved = [self.restaurants objectAtIndex:indexPath.row];
    
    Restaurant *restaurant = [self.restaurants objectAtIndex:indexPath.row];
    cell.nameLabel.text = restaurant.name;
    cell.addressLabel.text = restaurant.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate openRestaurant:[self.restaurants objectAtIndex:indexPath.row]];
}

@end
