//
//  UploadedPhotoTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"
#import "Dish.h"

@protocol UploadedPhotoDelegate <NSObject>

-(void)deleteUploadedPhoto;
-(void)likeDish:(BOOL)like;

@end

@interface UploadedPhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) id<UploadedPhotoDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet DesignableButton *likeButton;
@property (weak, nonatomic) IBOutlet DesignableButton *deleteButton;

@property (strong, nonatomic) Dish *dish;

-(void)configWithDish:(Dish*)dish andDelegate:(id)delegate;

@end
