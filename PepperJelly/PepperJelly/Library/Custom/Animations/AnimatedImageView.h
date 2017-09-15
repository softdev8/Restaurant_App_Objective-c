//
//  AnimatedImageView.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/1/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedImageView : UIImageView

@property (nonatomic, assign) float animationTime;
@property (nonatomic, assign) float animationDelay;
@property (nonatomic, assign) float animationForce;
@property (nonatomic, assign) int animationOption;
@property (nonatomic, assign) BOOL alphaAnimation;

-(void)setAlphaAnimationWithTime:(float)time delay:(float)delay option:(int)option force:(float)force;
-(void)setAlphaAnimationWithTime:(float)time timeSpan:(float)timeSpan delay:(float)delay delaySpan:(float)delaySpan option:(int)option force:(float)force forceSpan:(float)forceSpan;
-(void)startAnimation;

@end
