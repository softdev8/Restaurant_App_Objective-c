//
//  SingleGalleryTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantGalleryTableViewCell.h"
#import "RestaurantGalleryCollectionViewCell.h"
#import "UICollectionViewCell+Online.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation RestaurantGalleryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dishes = [[NSArray alloc] init];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configWithDishes:(NSArray *)dishes{
    self.dishes = dishes;
    [self.collectionView reloadData];
}

#pragma mark - CollectionView Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dishes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RestaurantGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    Dish *dish = [self.dishes objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dish.bigImageUrl] placeholderImage:PJ_IMAGE_PLACEHOLDER];
    
    
    //[cell setImageWithUrl:[dish thumbImageUrl] placeHolder:PJ_IMAGE_PLACEHOLDER showLoading:true imageViewName:@"imageView" collectionView:collectionView indexPath:indexPath completion:nil];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float size = [[UIScreen mainScreen] bounds].size.width/singleGalleryItems-(singleGallerySpacing*(singleGalleryItems-1));
    return CGSizeMake(size, size);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectDishFromGallery:[self.dishes objectAtIndex:indexPath.row]];
}

@end
