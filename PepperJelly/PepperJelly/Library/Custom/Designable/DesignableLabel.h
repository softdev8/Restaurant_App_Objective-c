//
//  DesignableLabel.h
//  PepperJelly
//
//  Created by Sean McCue on 4/22/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesignableLabel : UILabel
@property (nonatomic, assign) IBInspectable CGFloat insetX;
@property (nonatomic, assign) IBInspectable CGFloat insetY;

@end
