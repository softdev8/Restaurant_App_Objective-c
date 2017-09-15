//
//  ProfileCollectionViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ProfileUploadCollectionViewCell.h"
#import "FeedCollectionViewCell.h"
#import "Search.h"
#import "UIView+Loading.h"
#import "UIImage+Online.h"
#import "APIManager.h"
#import "UICollectionViewCell+Online.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define profileFeedsItems 3
#define profileFeedsSpacing 1.5

@implementation ProfileUploadCollectionViewCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    //enable to scrolltotop when tap on statusbar
    self.collectionView.scrollsToTop = true;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.feeds = [[NSMutableArray alloc] init];
    
    self.canLoadMore = true;
}

-(void)syncronize{
    if(!self.user)
        return;
    
    //sets what to search
    Search *search = [[Search alloc] init];
    search.userId = self.user.userId;
    if(self.page*FEED_PAGING_AMOUNT > 0) search.$skip = [NSNumber numberWithInteger:self.page*FEED_PAGING_AMOUNT];
    search.$limit = [NSNumber numberWithInteger:FEED_PAGING_AMOUNT];
    
    [[APIManager sharedInstance] searchDishesWithSearch:search completion:^(BOOL success, APIResponse *response) {
        
        //makes sure it doesn't clear the list if it's paging
        if(!isPaging)
            [self.feeds removeAllObjects];
        self.canLoadMore = true;
        
        //only add if has more results, otherwise will not let update
        if(response.results.count > 0)
            [self.feeds addObjectsFromArray:response.results];
        else
            self.canLoadMore = false;
        
        [self.collectionView reloadData];
        
        //scrolls to new items after reload
        if(isPaging && self.feeds.count > self.page*FEED_PAGING_AMOUNT)
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.page*FEED_PAGING_AMOUNT inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        else if(!isPaging && self.page == 0 && self.feeds.count > 0){
            if(self.collectionView.contentOffset.y != 0)
                self.canLoadMore = false;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        }
        
        isPaging = false;
    }];
}

-(void)nextPage{
    if(!self.canLoadMore)
        return;
    
    self.page++;
    self.canLoadMore = false;
    isPaging = true;
    
    [self syncronize];
}

#pragma mark - Events

- (IBAction)publishButtonPressed:(id)sender {
    [self.delegate openPublish];
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.feeds.count == 0){
        if([self.user.userId isEqualToString:[APIManager sharedInstance].user.userId])
            [self.collectionView showMessageWithText:NSLocalizedString(@"empty_uploaded", @"")];
        else
            [self.collectionView showMessageWithText:NSLocalizedString(@"empty_uploaded_otheruser", @"")];
    }else
        [self.collectionView hideMessage];
    
    return self.feeds.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"feed" forIndexPath:indexPath];
    
    Dish *dish = [self.feeds objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dish.thumbImageUrl] placeholderImage:PJ_IMAGE_PLACEHOLDER];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float size = [[UIScreen mainScreen] bounds].size.width/profileFeedsItems-(profileFeedsSpacing*(profileFeedsItems-1));
    return CGSizeMake(size, size);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate openUploadedPhoto:[self.feeds objectAtIndex:indexPath.row]];
}

#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float y = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom;
    if(y > scrollView.contentSize.height + FEED_NEXT_PAGE_OFFSET){
        if(self.canLoadMore){
            [self nextPage];
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.canLoadMore = true;
}

@end
