//
//  AlertBadgeView.h
//  PepperJelly
//
//  Created by Sean McCue on 7/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertBadgeProtocol.h"
#import "DesignableView.h"

@interface AlertBadgeView : UIView{
    BOOL animating;
}

@property (nonatomic, assign) id <AlertBadgeDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet DesignableView *badgeBallView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

-(void)showWithBadgeCount:(NSInteger)count;
-(void)hide;

@end
