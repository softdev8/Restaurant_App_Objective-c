//
//  FeedTypeCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FeedAll,
    FeedFollowing
}FeedType;

typedef NS_ENUM(NSInteger, MenuOption) {
    MenuOptionNone,
    MenuOptionNearMe,
    MenuOptionItalian,
    MenuOptionBreakfast,
    MenuOptionSandwiches,
//    MenuOptionHeatingUp,
    MenuOptionSushi,
    MenuOptionMexican,
    MenuOptionBurgers,
    MenuOptionDrinks,
    MenuOptionCoffeeTea,
    MenuOptionDesserts,
    MenuOptionHealthy,
    MenuOptionVegetarian,
    MenuOptionPizza,
    MenuOptionNoodles,
    MenuOptionFind,
    MenuOptionViewAll
};

@protocol FeedTypeDelegate <NSObject>
-(void)openFeed:(id)feed sender:(id)sender frame:(CGRect)frame;
-(void)changeLocation;
-(void)feedDidScroll;
-(void)mainMenuOptionSelected;
-(void)showFiltersWithSender:(id)sender;
@end

@interface FeedTypeCollectionViewCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource>{
    BOOL isPaging;
}

@property (nonatomic, weak) UIViewController<FeedTypeDelegate>* feedTypeDelegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *feeds;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) FeedType feedType;
@property (nonatomic, assign) MenuOption selectedMenuOption;

-(void)syncronize;

@end
