//
//  SinglePhotoTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantPhotoTableViewCell.h"
#import "RestaurantPhotoCollectionViewCell.h"
#import "UIColor+PepperJelly.h"
#import "UIView+Loading.h"
#import "UIImage+Online.h"
#import "APIManager.h"
#import "Comment.h"
#import "UICollectionViewCell+Online.h"
#import "LikeAnimationImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>

@implementation RestaurantPhotoTableViewCell{
    BOOL dragging;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configWithDishes:(NSArray *)dishes atPosition:(int)position showPlaceholder:(BOOL)showPlaceholder selectedImage:(UIImage *)selectedImage{
    self.showPlaceholder = showPlaceholder;
    self.selectedImage = selectedImage;
    
    BOOL shouldReload = position == 0 || self.dishes.count != dishes.count;
    self.dishes = dishes;
    
    NSMutableArray * urls = [NSMutableArray arrayWithCapacity:dishes.count];
    for (Dish *d in dishes) {
        [urls addObject:[NSURL URLWithString:d.bigImageUrl] ];
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
    
    if(self.dishes.count > 0){
        [self updateInfoWithDish:[dishes objectAtIndex:position]];
        
        if(shouldReload){
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:position inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }else if (self.selectedImage){
        self.moreLabel.text = @"";
        [self.likeButton setTitle:@"0" forState:UIControlStateNormal];
        [self.collectionView reloadData];
    }
}

-(void)updateInfoWithDish:(Dish*)dish{
    self.dish = [Dish dishWithId:dish.dishId];
    
    //like button
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]] forState:UIControlStateNormal];
    self.likeButton.selected = [self.dish.currentUserLike boolValue];
    self.likeButton.backgroundColor = self.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
    
    //caption
    self.moreLabel.text = @"";
    if(self.dish.comments.count > 0){
        Comment *comment = [[self.dish.comments allObjects] objectAtIndex:0];
        self.moreLabel.text = EXCERPT(comment.comment, EXCERPT_MAX_LENGTH);
        self.moreLabel.translatesAutoresizingMaskIntoConstraints = true;
        [self.moreLabel sizeToFit];
        self.moreLabel.center = self.moreButton.center;
        self.moreImageView.center = CGPointMake(self.moreLabel.frame.origin.x+self.moreLabel.frame.size.width+5+self.moreImageView.frame.size.width/2, self.moreImageView.center.y);
    }else{
        //centers arrow in case of no comments
        self.moreImageView.translatesAutoresizingMaskIntoConstraints = true;
        self.moreImageView.center = self.moreButton.center;
    }
}

#pragma mark - Events
- (IBAction)likeButtonPressed:(id)sender {
    
    if(!self.likeButton.selected){
        LikeAnimationImageView *likeView = [[LikeAnimationImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        likeView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self addSubview:likeView];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        self.likeButton.selected = !self.likeButton.selected;
        self.likeButton.backgroundColor = self.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
        
        if(self.likeButton.selected)
            [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]+1] forState:UIControlStateNormal];
        else
            [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]-1] forState:UIControlStateNormal];
        
        self.likeButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.likeButton.transform = CGAffineTransformMakeScale(1, 1);
        }completion:^(BOOL finished) {
            [self startLoading];
            [[APIManager sharedInstance] likeDishWithId:self.dish.dishId like:self.likeButton.selected completion:^(BOOL success, APIResponse *response) {
                [self stopLoading];
                if(success){
                    if(self.likeButton.selected)
                        self.dish.likes = [NSNumber numberWithInt:[self.dish.likes intValue]+1];
                    else
                        self.dish.likes = [NSNumber numberWithInt:[self.dish.likes intValue]-1];
                    [CDHelper save];
                    
                    self.likeButton.backgroundColor = self.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
                    [self.delegate likeDish:self.likeButton.selected];
                }else{
                    self.likeButton.selected = !self.likeButton.selected;
                    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]] forState:UIControlStateNormal];
                }
            }];
        }];
    }];
}

- (IBAction)moreButtonPressed:(id)sender {
    CGPoint originalCenter = self.moreView.center;
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.moreView.center = CGPointMake(self.moreView.center.x, self.moreView.center.y-self.moreView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.moreView.alpha = 0;
            self.moreView.center = CGPointMake(self.moreView.center.x, self.frame.size.height+self.moreView.frame.size.height/2);
        } completion:^(BOOL finished) {
            self.moreView.hidden = true;
            self.moreView.alpha = 1;
            self.moreView.center = originalCenter;
            
            [self.delegate showPhotoDetails:true];
        }];
    }];
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.dishes.count == 0)
        return 1;
    return self.dishes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RestaurantPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    if(self.dishes.count == 0){
        cell.imageView.image = self.selectedImage;
    }else{
        Dish *dish = [self.dishes objectAtIndex:indexPath.row];
        if(indexPath.row == 0)
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dish.bigImageUrl] placeholderImage:self.selectedImage];
        
            //[cell setImageWithUrl:dish.image placeHolder:self.selectedImage showLoading:false imageViewName:@"imageView" collectionView:collectionView indexPath:indexPath completion:nil];
        else
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dish.bigImageUrl] placeholderImage:PJ_IMAGE_PLACEHOLDER];
            //[cell setImageWithUrl:dish.image thumbnail:[dish thumbImageUrl] placeHolder:(self.showPlaceholder ? PJ_IMAGE_PLACEHOLDER : nil) showLoading:false imageViewName:@"imageView" collectionView:collectionView indexPath:indexPath completion:nil];
    }

    return cell;
}

-(void)doubleTap:(UITapGestureRecognizer*)sender{
    [self likeButtonPressed:nil];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float size = [[UIScreen mainScreen] bounds].size.width;
    return CGSizeMake(size, size);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dragging = true;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = (self.collectionView.contentOffset.x / self.collectionView.frame.size.width);
    
    if(dragging){
        dragging = false;
        [self.delegate didChangeDish:currentPage];
        [self updateInfoWithDish:[self.dishes objectAtIndex:currentPage]];
    }
}

#pragma mark - Delegate
@end
