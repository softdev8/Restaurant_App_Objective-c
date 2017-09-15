//
//  LoadingView.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

+(LoadingView*)loadingView{
    return [[[NSBundle bundleForClass:self] loadNibNamed:@"LoadingView" owner:self options:nil] objectAtIndex:0];
}

-(void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    self.loadingScale = 1;
}

//-(instancetype)initWithFrame:(CGRect)frame backgroundLocked:(BOOL)backgroundLocked{
//    self = [super initWithFrame:frame];
//    if(self){
//        NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
//        [self addSubview:[xibViews objectAtIndex:0]];
//        self.backgroundColor = [UIColor clearColor];
//        
//        //disables backgroundlock
//        if(!backgroundLocked)
//            self.frame = CGRectMake(frame.size.width/2-self.mainView.frame.size.width/2, frame.size.height/2-self.mainView.frame.size.height/2, self.mainView.frame.size.width, self.mainView.frame.size.height);
//        self.mainView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        self.mainView.backgroundColor = [UIColor clearColor];
//    }
//    return self;
//}

#pragma mark - Animations

-(void)startAnimating{
    self.activityView.alpha = 0;
    self.activityView.transform = CGAffineTransformMakeScale(0.5f*self.loadingScale, 0.5f*self.loadingScale);
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.activityView.alpha = 1;
        self.activityView.transform = CGAffineTransformMakeScale(1*self.loadingScale, 1*self.loadingScale);
    } completion:^(BOOL finished) {
        
    }];
    
    if (!self.animating) {
        self.animating = YES;
        [self makeSpinAnimationWithOptions:UIViewAnimationOptionCurveEaseIn];
    }
}

-(void)stopAnimating{
    self.animating = NO;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.activityView.alpha = 0;
        self.activityView.transform = CGAffineTransformMakeScale(1.3f*self.loadingScale, 1.3f*self.loadingScale);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)makeSpinAnimationWithOptions:(UIViewAnimationOptions)options{
    [UIView animateWithDuration:0.3f delay:0 options:options animations:^{
        self.activityView.transform = CGAffineTransformRotate(self.activityView.transform, M_PI_2 / 2);
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.animating) {
                // if flag still set, keep spinning with constant speed
                [self makeSpinAnimationWithOptions: UIViewAnimationOptionCurveLinear];
            } else if (options != UIViewAnimationOptionCurveEaseOut) {
                // one last spin, with deceleration
                [self makeSpinAnimationWithOptions: UIViewAnimationOptionCurveEaseOut];
            }
        }
    }];
}

@end
