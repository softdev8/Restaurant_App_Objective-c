//
//  LoadingView.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableView.h"

@interface LoadingView : UIView

@property (strong, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet DesignableView *ball1View;
@property (weak, nonatomic) IBOutlet DesignableView *ball2View;
@property (weak, nonatomic) IBOutlet DesignableView *ball3View;
@property (assign, nonatomic) float loadingScale;

@property (assign, nonatomic) BOOL animating;

//-(instancetype)initWithFrame:(CGRect)frame backgroundLocked:(BOOL)backgroundLocked;
+(LoadingView*)loadingView;

-(void)startAnimating;
-(void)stopAnimating;

@end
