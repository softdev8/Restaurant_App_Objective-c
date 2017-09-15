//
//  FilterDetailsViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 06/07/2016.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryItem.h"

@protocol FindCategoryDelegate <NSObject>
-(void)handleCategoriesSelected:(NSArray *)categories;
@end

@interface FilterDetailsViewController : UIViewController

@property (nonatomic, strong) CategoryItem *categoryItem;
@property (nonatomic, weak) id<FindCategoryDelegate> delegate;

@end
