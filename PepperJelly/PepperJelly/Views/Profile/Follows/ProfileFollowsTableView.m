//
//  ProfileFollowsViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/8/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileFollowsTableView.h"
#import "ProfileFollowsTableViewCell.h"
#import "APIManager.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"
#import "UITableViewCell+Online.h"

@interface ProfileFollowsTableView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *list;

@end

@implementation ProfileFollowsTableView

-(void)awakeFromNib{
    
    //enable to scrolltotop when tap on statusbar
    self.scrollsToTop = true;
    
    self.delegate = self;
    self.dataSource = self;
    
    self.list = [[NSMutableArray alloc] init];
}

-(void)updateWithList:(NSArray *)list{
    [self.list removeAllObjects];
    [self.list addObjectsFromArray:list];
    
    [self reload];
}

-(void)reload{
    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    User *user = [self.list objectAtIndex:indexPath.row];
    
    BOOL following = [[APIManager sharedInstance].user.followingUsers containsObject:user];
    
    ProfileFollowsTableViewCell *cell;
    if(following)
        cell = [tableView dequeueReusableCellWithIdentifier:@"unfollow" forIndexPath:indexPath];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"follow" forIndexPath:indexPath];
    
    [cell configWithUser:user following:following delegate:self.profileDelegate];
    
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
    [self.profileDelegate didSelectUser:[self.list objectAtIndex:indexPath.row]];
}

@end
