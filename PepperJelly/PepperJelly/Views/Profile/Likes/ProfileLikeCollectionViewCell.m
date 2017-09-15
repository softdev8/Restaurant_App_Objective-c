//
//  ProfileLikeCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileLikeCollectionViewCell.h"
#import "Search.h"
#import "UIView+Loading.h"
#import "UIImage+Online.h"
#import "APIManager.h"

@implementation ProfileLikeCollectionViewCell

-(void)syncronize{
    if(!self.user)
        return;
    
    [self startLoading];
    [[APIManager sharedInstance] getLikedDishesWithCompletion:^(BOOL success, APIResponse *response) {
        [self stopLoading];
        [self.feeds removeAllObjects];
        [self.feeds addObjectsFromArray:response.results];
        
        [self.collectionView reloadData];
    }];
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.feeds.count == 0){
        if([self.user.userId isEqualToString:[APIManager sharedInstance].user.userId])
            [self.collectionView showMessageWithText:NSLocalizedString(@"empty_liked", @"")];
        else
            [self.collectionView showMessageWithText:NSLocalizedString(@"empty_liked_otheruser", @"")];
    }else
        [self.collectionView hideMessage];
    
    return self.feeds.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate openLikedPhoto:[self.feeds objectAtIndex:indexPath.row]];
}

@end
