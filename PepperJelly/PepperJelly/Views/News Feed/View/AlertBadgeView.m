//
//  AlertBadgeView.m
//  PepperJelly
//
//  Created by Sean McCue on 7/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "AlertBadgeView.h"

@implementation AlertBadgeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self loadView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self loadView];
    }
    return self;
}

-(void)loadView{
    UIView *view = (UIView *)[[NSBundle mainBundle] loadNibNamed:@"AlertBadge" owner:self options:nil].firstObject;
    view.frame = self.bounds;
    [self addSubview:view];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.hidden = true;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.badgeBallView.frame.size.height);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.delegate userPressedBadge];
}


-(void)showWithBadgeCount:(NSInteger)count{
//    if(animating || !self.contentView.hidden)
//        return;
//    animating = true;
    
    self.contentView.hidden = false;
    self.contentView.alpha = 0;
    self.contentView.transform = CGAffineTransformMakeScale(1, 0.1);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 57);
    self.badgeLabel.text = [NSString stringWithFormat:@"+%ld", (long)count];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1, 1);
        }completion:^(BOOL finished) {
            animating = false;
        }];
    }];
}

-(void)hide{
    if(animating || self.contentView.hidden)
        return;
    animating = true;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.contentView.alpha = 0;
        }completion:^(BOOL finished) {
            self.contentView.hidden = true;
            animating = false;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.badgeBallView.frame.size.height);
        }];
    }];
}

@end
