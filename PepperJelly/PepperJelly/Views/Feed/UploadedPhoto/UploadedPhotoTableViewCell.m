//
//  UploadedPhotoTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UploadedPhotoTableViewCell.h"
#import "UIView+Loading.h"
#import "APIManager.h"
#import "UIColor+PepperJelly.h"
#import "LikeAnimationImageView.h"

@implementation UploadedPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)doubleTap:(UITapGestureRecognizer*)sender{
    [self likeButtonPressed:nil];
}

-(void)configWithDish:(Dish *)dish andDelegate:(id)delegate{
    self.dish = dish;
    self.delegate = delegate;
    
//    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]] forState:UIControlStateNormal];
//    self.likeButton.userInteractionEnabled = false;
//    self.likeButton.selected = true;
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]] forState:UIControlStateNormal];
    self.likeButton.selected = [self.dish.currentUserLike boolValue];
    self.likeButton.backgroundColor = self.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
    
    //if is another user, hides delete button and enable like button
    if(![self.dish.user.userId isEqualToString:[APIManager sharedInstance].user.userId]){
        self.deleteButton.hidden = YES;
        
        self.likeButton.userInteractionEnabled = true;
        self.likeButton.selected = [self.dish.currentUserLike boolValue];
    }
    
    self.likeButton.backgroundColor = self.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
}

#pragma mark - Events

- (IBAction)deleteButtonPressed:(id)sender {
    [self.delegate deleteUploadedPhoto];
}

- (IBAction)likeButtonPressed:(id)sender {
    
    
    if(!self.likeButton.selected){
        LikeAnimationImageView *likeView = [[LikeAnimationImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        likeView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [self addSubview:likeView];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        self.likeButton.selected = !self.likeButton.selected;
        self.likeButton.backgroundColor = self.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
        
        if(self.likeButton.selected)
            [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]+1] forState:UIControlStateNormal];
        else
            [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]-1] forState:UIControlStateNormal];
        
        self.likeButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.likeButton.transform = CGAffineTransformMakeScale(1, 1);
        }completion:^(BOOL finished) {
            //[self startLoading];
            [[APIManager sharedInstance] likeDishWithId:self.dish.dishId like:self.likeButton.selected completion:^(BOOL success, APIResponse *response) {
                //[self stopLoading];
                if(success){
                    if(self.likeButton.selected)
                        self.dish.likes = [NSNumber numberWithInt:[self.dish.likes intValue]+1];
                    else
                        self.dish.likes = [NSNumber numberWithInt:[self.dish.likes intValue]-1];
                    [CDHelper save];
                    
                    self.likeButton.backgroundColor = self.likeButton.selected ? [UIColor pepperjellyPinkColor] : [UIColor whiteColor];
                    [self.delegate likeDish:self.likeButton.selected];
                }else{
                    self.likeButton.selected = !self.likeButton.selected;
                    [self.likeButton setTitle:[NSString stringWithFormat:@"%d", [self.dish.likes intValue]] forState:UIControlStateNormal];
                }
            }];
        }];
    }];
}

@end
