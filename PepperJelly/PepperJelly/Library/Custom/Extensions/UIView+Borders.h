//
//  UIView+Borders.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Borders)

- (CALayer *)addBorderToEdge:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness;

@end
