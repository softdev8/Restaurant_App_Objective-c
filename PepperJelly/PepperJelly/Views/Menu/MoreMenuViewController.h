//
//  MoreMenuViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "Restaurant.h"

@protocol MoreMenuDelegate <NSObject>

@optional
-(void)moreMenuWillClose;
-(void)moreMenuDidDeleteDish;

@end

@interface MoreMenuViewController : UIViewController

@property (nonatomic, weak) id<MoreMenuDelegate> delegate;

@property (nonatomic, strong) Dish *dish;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Restaurant *restaurant;

-(void)hideContentWithCompletion:(void (^)())completion;

@end
