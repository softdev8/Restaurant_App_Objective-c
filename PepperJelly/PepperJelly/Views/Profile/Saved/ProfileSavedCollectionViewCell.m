//
//  ProfileSavedCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileSavedCollectionViewCell.h"
#import "ProfileSavedTableViewCell.h"
#import "UIView+Loading.h"
#import "Restaurant.h"
#import "CDHelper.h"

@implementation ProfileSavedCollectionViewCell

-(void)awakeFromNib{
    
    //enable to scrolltotop when tap on statusbar
    self.tableView.scrollsToTop = true;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.saved = [[NSMutableArray alloc] init];
    [self syncronize];
}

-(void)syncronize{
    [self.saved removeAllObjects];
    [self.saved addObjectsFromArray:[Restaurant getSaved]];
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.saved.count == 0)
        [self showMessageWithText:NSLocalizedString(@"empty_saved_restaurants", @"")];
    else
        [self hideMessage];
    
    return self.saved.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileSavedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"saved" forIndexPath:indexPath];
    cell.saved = [self.saved objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    Restaurant *restaurant = [self.saved objectAtIndex:indexPath.row];
    cell.nameLabel.text = restaurant.name;
    cell.addressLabel.text = restaurant.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate openRestaurant:[self.saved objectAtIndex:indexPath.row]];
}

#pragma mark - Profile Saved Delegate

-(void)deleteSaved:(Restaurant*)saved{
    NSInteger index = [self.saved indexOfObject:saved];
    [self.saved removeObjectAtIndex:index];
    saved.saved = [NSNumber numberWithBool:NO];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
}

@end
