//
//  FeedProtocols.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/14/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#ifndef RestaurantProtocols_h
#define RestaurantProtocols_h
#import "Dish.h"

@protocol RestaurantDelegate <NSObject>
-(void)likeDish:(BOOL)like;

@optional
-(void)saveRestaurant;
-(void)toggleOpeningHours;
-(void)didChangeDish:(int)position;

-(void)didSelectDishFromGallery:(Dish*)dish;
-(void)showPhotoDetails:(BOOL)show;
-(void)didTapRestaurantViewsCount;
-(NSString *)dateDiff:(NSString *)origDate;

@end

#endif /* FeedProtocols_h */
