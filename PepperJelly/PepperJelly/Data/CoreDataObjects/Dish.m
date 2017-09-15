//
//  Dish.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "Dish.h"
#import "Comment.h"
#import "User.h"
#import "CDHelper.h"
#import "DishData.h"
#import "CommentData.h"
#import "DishImage.h"
#import <UIKit/UIKit.h>
#import "APIManager.h"
#import <Cloudinary/Cloudinary-Swift.h>
#import <SDWebImage/SDWebImagePrefetcher.h>


@implementation Dish

+(Dish *)dishWithId:(NSString *)dishId{
    
    NSArray *dishes = [CDHelper list:@"Dish" withProperty:@"dishId" andValue:dishId sort:@"" ascending:YES];
    
    //NSArray *dishes = [CDHelper list:@"Dish" sort:@"" ascending:YES];
    
    for(Dish *dish in dishes)
        if([dish.dishId isEqualToString:dishId])
            return dish;
    
    return nil;
}

+(Dish *)createWithId:(NSString *)dishId{
    Dish *dish = [self dishWithId:dishId];
    
    if(dish)
        return dish;
    
    dish = [CDHelper insert:@"Dish"];
    dish.dishId = dishId;
    return dish;
}

+(Dish *)dishWithDishData:(DishData *)dishData{
    Dish *dish = [self createWithId:dishData._id];
    //dish.image = dishData.image;
    dish.restaurantId = dishData.restaurantId;
    dish.userId = dishData.userId;
    dish.status = dishData.status;
    dish.likes = dishData.likes;
    dish.createdAt = dishData.createdAt;
    
    if([dishData.currentUserLike respondsToSelector:@selector(intValue)]){
        dish.currentUserLike = dishData.currentUserLike;
    }
    
    [dish clearComments];
    if(dishData.comments && [dishData.comments isKindOfClass:[NSArray class]]){
        for(CommentData *commentData in dishData.comments){
            Comment *comment = [CDHelper insert:@"Comment"];
            comment.commentId = commentData._id;
            comment.comment = commentData.comment;
            comment.dishId = commentData.dishId;
            comment.userId = commentData.userId;
            comment.userName = commentData.userName;
            comment.timeStamp = commentData.timeStamp;
            comment.dish = dish;
            [dish addCommentsObject:comment];
        }
    }
    
    [dish clearImages];
    if(dishData.image && [dishData.image isKindOfClass:[NSArray class]]){
        for(DishImageData *imageData in dishData.image){
            DishImage *image = [CDHelper insert:@"DishImage"];
            image.url = imageData.url;
            image.width = imageData.width;
            image.height = imageData.height;
            image.dish = dish;
            [dish addImagesObject:image];
        }
        
        dish.image = [dish bigImageUrl];
    }
    

    
    User *user = [User userWithUserData:dishData.user];
    [user addDishesObject:dish];
    dish.user = user;
    
    return dish;
}

+(NSArray *)getAll{
    return [CDHelper list:@"Dish" sort:@"createdAt" ascending:NO];
}

+(NSArray *)dishesWithRestaurantId:(NSString *)restaurantId{
    NSArray *dishes = [CDHelper list:@"Dish" sort:@"createdAt" ascending:YES];
    
    NSMutableArray *restaurantDishes = [[NSMutableArray alloc] init];
    for(Dish *dish in dishes)
        if([dish.restaurantId isEqualToString:restaurantId])
            [restaurantDishes addObject:dish];
    
    return restaurantDishes;
}

-(void)clearComments{
    [[self mutableSetValueForKey:@"comments"] removeAllObjects];
}

-(void)clearImages{
    [[self mutableSetValueForKey:@"images"] removeAllObjects];
}

-(NSString *)thumbImageUrl{
    NSString *url = self.image;
    
    NSArray *images = [CDHelper sortArray:[self.images allObjects] by:@"width" ascending:YES];
    if(images.count > 0)
        url = (NSString*)[[images firstObject] url];
    
    if([url containsString:kAWSURLBase])
        url = [url stringByReplacingOccurrencesOfString:kAWSURLBase withString:@"s3/"];
    
    CLDConfiguration *cloudinary_config = [[CLDConfiguration alloc] initWithCloudinaryUrl:kCloudinaryURL];
    CLDCloudinary *cloudinary = [[CLDCloudinary alloc] initWithConfiguration:cloudinary_config networkAdapter:nil sessionConfiguration:nil];
    CLDTransformation *transform = [[CLDTransformation alloc] init];
    [transform setQuality:@"auto:good"];
    [transform setWidth:@"300"];
    [transform setHeight:@"300"];
    //[transform setEffect:@"improve"];
    [transform setCrop:@"fit"];
    
    if([url containsString:@"google"]) {
        NSMutableArray *url_parts = [NSMutableArray arrayWithArray:[url componentsSeparatedByString: @"/"]];
        [url_parts removeObjectAtIndex:[url_parts count]-2];
        
        url = [url_parts componentsJoinedByString:@"/"];
        return [[[[cloudinary createUrl] setTypeFromType:CLDTypeFetch] setTransformation:transform] generate:url signUrl:NO];
    }
    
    return [[[cloudinary createUrl] setTransformation:transform] generate:url signUrl:NO];

    
    return url;
}

-(NSString*)mediumImageUrl {
    NSString *url = self.image;
    
    NSArray *images = [CDHelper sortArray:[self.images allObjects] by:@"width" ascending:YES];
    if(images.count > 0)
        url = (NSString*)[images[1] url];
    
    return url;
}

-(NSString *)bigImageUrl{
    NSString *url = self.image;
    
    NSArray *images = [CDHelper sortArray:[self.images allObjects] by:@"width" ascending:YES];
    
    //for iPhone6+, it will get the biggest image
    if(images.count > 1 && [[UIScreen mainScreen] bounds].size.width <= 375){
        url = (NSString*)[[images objectAtIndex:1] url];
    }else if(images.count > 0){
        if([[UIScreen mainScreen] bounds].size.width < 375 && images.count > 1)
            url = (NSString*)[[images objectAtIndex:1] url];
        else
            url = (NSString*)[[images lastObject] url];
    }
    
//    if(![url containsString:@"http"])
//        url = [url stringByReplacingOccurrencesOfString:@"images-prod.s3-website-us-west-2.amazonaws.com" withString:kAWSURL];
    
    
    if([url containsString:kAWSURLBase])
        url = [url stringByReplacingOccurrencesOfString:kAWSURLBase withString:@"s3/"];
    
    CLDConfiguration *cloudinary_config = [[CLDConfiguration alloc] initWithCloudinaryUrl:kCloudinaryURL];
    CLDCloudinary *cloudinary = [[CLDCloudinary alloc] initWithConfiguration:cloudinary_config networkAdapter:nil sessionConfiguration:nil];
    CLDTransformation *transform = [[CLDTransformation alloc] init];
    [transform setQuality:@"auto:good"];
    [transform setWidth:@"800"];
    [transform setHeight:@"800"];
    //[transform setEffect:@"improve"];
    [transform setCrop:@"fit"];
    
    if([url containsString:@"google"]) {
        NSMutableArray *url_parts = [NSMutableArray arrayWithArray:[url componentsSeparatedByString: @"/"]];
        [url_parts removeObjectAtIndex:[url_parts count]-2];
        
        url = [url_parts componentsJoinedByString:@"/"];
        return [[[[cloudinary createUrl] setTypeFromType:CLDTypeFetch] setTransformation:transform] generate:url signUrl:NO];
    }
    
    return [[[cloudinary createUrl] setTransformation:transform] generate:url signUrl:NO];

    
    return url;
}

@end
