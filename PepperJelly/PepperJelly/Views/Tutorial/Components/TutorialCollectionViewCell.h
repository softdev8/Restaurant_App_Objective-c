//
//  TutorialCollectionViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialCollectionViewCell : UICollectionViewCell{
    CGPoint animationViewOriginalCenter;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *animationView;

-(void)prepareForAnimation;
-(void)animateIn;

@end
