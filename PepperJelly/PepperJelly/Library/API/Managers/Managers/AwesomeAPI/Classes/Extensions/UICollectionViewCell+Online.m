//
//  UICollectionViewCell+Online.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/23/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UICollectionViewCell+Online.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"

@implementation UICollectionViewCell (Online)

-(void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeholder showLoading:(BOOL)showLoading imageViewName:(NSString*)imageViewName collectionView:(UICollectionView*)collectionView indexPath:(NSIndexPath*)indexPath completion:(void (^)(UIImage *image))completion{
    
    //return;
    
    id imageView = [self valueForKey:imageViewName];
    if(!imageView){
        NSLog(@"Image View called %@ does not exist!", imageViewName);
        return;
    }
    
    [imageView layer].masksToBounds = true;
    
    if(placeholder)
        [imageView setImage:placeholder];
    
    if(showLoading)
        [imageView startLoading];
    [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
        [imageView stopLoading];
        id updateCell = [collectionView cellForItemAtIndexPath:indexPath];
        if(updateCell){
            id imageView = [updateCell valueForKey:imageViewName];
            [imageView stopLoading];
            [imageView setImage:image];
        }
    }];
}


-(void)setImageWithUrl:(NSString *)url thumbnail:(NSString *)thumbnail placeHolder:(UIImage *)placeholder showLoading:(BOOL)showLoading imageViewName:(NSString *)imageViewName collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath completion:(void (^)(UIImage *))completion{
    
    //return;
    
    id imageView = [self valueForKey:imageViewName];
    if(!imageView){
        NSLog(@"Image View called %@ does not exist!", imageViewName);
        return;
    }
    
    [imageView layer].masksToBounds = true;
    
    if(placeholder)
        [imageView setImage:placeholder];
    
    if(showLoading)
        [imageView startLoading];
    [UIImage imageWithUrl:thumbnail placeHolder:placeholder completion:^(UIImage *image) {
        if(image){
            id updateCell = [collectionView cellForItemAtIndexPath:indexPath];
            if(updateCell){
                id imageView = [updateCell valueForKey:imageViewName];
                [imageView stopLoading];
                [imageView setImage:image];
            }
        }
        
        [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
            [imageView stopLoading];
            id updateCell = [collectionView cellForItemAtIndexPath:indexPath];
            if(updateCell){
                id imageView = [updateCell valueForKey:imageViewName];
                [imageView setImage:image];
                [imageView stopLoading];
            }
        }];
    }];
}

@end
