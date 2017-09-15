//
//  UITableViewCell+Online.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/23/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UITableViewCell+Online.h"
#import "UIImage+Online.h"
#import "UIView+Loading.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UITableViewCell (Online)

-(void)setImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeholder showLoading:(BOOL)showLoading imageViewName:(NSString*)imageViewName tableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath completion:(void (^)(UIImage *image))completion{
    
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
    
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageView stopLoading];
        id updateCell = [tableView cellForRowAtIndexPath:indexPath];
        if(updateCell){
            id imageView = [updateCell valueForKey:imageViewName];
            [imageView stopLoading];
            //[imageView setImage:image];
        }
    }];

    
//    [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
//        [imageView stopLoading];
//        id updateCell = [tableView cellForRowAtIndexPath:indexPath];
//        if(updateCell){
//            id imageView = [updateCell valueForKey:imageViewName];
//            [imageView stopLoading];
//            [imageView setImage:image];
//        }
//    }];
}

-(void)setImageWithUrl:(NSString *)url thumbnail:(NSString *)thumbnail placeHolder:(UIImage *)placeholder showLoading:(BOOL)showLoading imageViewName:(NSString *)imageViewName tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath completion:(void (^)(UIImage *))completion{
    
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
            id updateCell = [tableView cellForRowAtIndexPath:indexPath];
            if(updateCell){
                [imageView stopLoading];
                id imageView = [updateCell valueForKey:imageViewName];
                [imageView setImage:image];
            }
        }
        
        [UIImage imageWithUrl:url placeHolder:placeholder completion:^(UIImage *image) {
            [imageView stopLoading];
            id updateCell = [tableView cellForRowAtIndexPath:indexPath];
            if(updateCell){
                id imageView = [updateCell valueForKey:imageViewName];
                [imageView setImage:image];
                [imageView stopLoading];
            }
        }];
    }];
}

@end
