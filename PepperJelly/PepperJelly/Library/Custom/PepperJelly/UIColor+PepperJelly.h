//
//  UIColor+UIColor_PepperJelly.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/22/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PepperJelly)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

+(UIColor *)whitesmokeBackgroundColor;
+(UIColor *)lightGreyColor;
+(UIColor *)mediumGreyColor;
+(UIColor *)warmGreyColor;
+(UIColor *)darkGreyColor;
+(UIColor *)greyishBrownColor;
+(UIColor *)pepperjellyPinkColor;
+(UIColor *)facebookBlue;
+(UIColor *)paleRed;
+(UIColor *)navigationBarColor;
+(UIColor *)navigationBarItemColor;
+(UIColor *)navigationTitleColor;
+(UIColor *)followOrange;

+(UIImage *)imageFromColor:(UIColor *)color;

@end
