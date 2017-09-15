//
//  SearchUserCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/17/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "SearchUserCollectionViewCell.h"
#import "ProfileFollowsTableViewCell.h"
#import "APIManager.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"
#import "UITableViewCell+Online.h"

@implementation SearchUserCollectionViewCell

-(void)awakeFromNib{
    
    //enable to scrolltotop when tap on statusbar
    self.tableView.scrollsToTop = true;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.users = [[NSMutableArray alloc] init];
}

-(void)updateWithUsers:(NSArray *)users searchString:(NSString*)searchString{
    self.searchString = searchString;
    
    [self.users removeAllObjects];
    [self.users addObjectsFromArray:users];
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.users.count == 0 && self.searchString.length > 0)
        [self showMessageWithText:NSLocalizedString(@"empty_search_users", @"")];
    else
        [self hideMessage];
    
    return self.users.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    User *user = [self.users objectAtIndex:indexPath.row];
    
    BOOL following = [[APIManager sharedInstance].user.followingUsers containsObject:user];
    
    ProfileFollowsTableViewCell *cell;
    if(following)
        cell = [tableView dequeueReusableCellWithIdentifier:@"unfollow" forIndexPath:indexPath];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"follow" forIndexPath:indexPath];
    
    [cell configWithUser:user following:following delegate:self];
    
    //makes sure user can't follow himself
    if([user.userId isEqualToString: [APIManager sharedInstance].user.userId]){
        cell.followButton.hidden = true;
        cell.titleLabel.translatesAutoresizingMaskIntoConstraints = true;
        cell.titleLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y, cell.frame.size.width-cell.titleLabel.frame.origin.x, cell.titleLabel.frame.size.height);
    }
    
    //profile picture
    [cell setImageWithUrl:user.userImage placeHolder:PJ_IMAGE_PLACEHOLDER showLoading:true imageViewName:@"profileImageView" tableView:tableView indexPath:indexPath completion:nil];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate openUser:[self.users objectAtIndex:indexPath.row]];
}

#pragma mark - Profile Delegate

-(void)followUser:(User *)user{
    [self startLoading];
    [[APIManager sharedInstance] followUserWithId:user.userId completion:^(BOOL success, APIResponse *response) {
        [self stopLoading];
        [self.tableView reloadData];
    }];
}

-(void)unfollowUser:(User *)user{
    [self startLoading];
    [[APIManager sharedInstance] unfollowUserWithId:user.userId completion:^(BOOL success, APIResponse *response) {
        [self stopLoading];
        [self.tableView reloadData];
    }];
}

@end
