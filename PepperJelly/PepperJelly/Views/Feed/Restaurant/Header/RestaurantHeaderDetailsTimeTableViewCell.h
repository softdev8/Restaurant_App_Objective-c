//
//  RestaurantHeaderDetailsTimeTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/20/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantHeaderDetailsTimeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;

-(void)animateIn;
-(void)animateOutWithCompletion:(void (^)())completion;

@end
