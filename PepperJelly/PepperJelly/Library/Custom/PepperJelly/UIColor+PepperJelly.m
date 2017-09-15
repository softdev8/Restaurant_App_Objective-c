//
//  UIColor+UIColor_PepperJelly.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/22/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "UIColor+PepperJelly.h"

@implementation UIColor (PepperJelly)

+(UIColor *)whitesmokeBackgroundColor{
    return [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
}

+(UIColor *)lightGreyColor{
    return RGBA(228, 228, 228, 1);
}

+(UIColor *)mediumGreyColor{
    return RGBA(173, 173, 173, 1);
}

+(UIColor *)warmGreyColor{
    return RGBA(151, 151, 151, 1);
}

+(UIColor *)darkGreyColor{
    return RGBA(62, 62, 62, 1);
}

+(UIColor *)greyishBrownColor{
    return RGBA(74, 74, 74, 1);
}

+(UIColor *)pepperjellyPinkColor{
    return RGBA(244, 16, 80, 1);
}

+(UIColor *)facebookBlue{
    return RGBA(72, 93, 199, 1);
}

+(UIColor *)paleRed{
    return RGBA(219, 72, 63, 1);
}

+(UIColor *)navigationBarColor{
    return RGBA(246, 246, 246, 1);
}

+(UIColor *)navigationBarItemColor{
    return [self pepperjellyPinkColor];
}

+(UIColor *)navigationTitleColor{
    return [self greyishBrownColor];
}

+(UIColor *)followOrange{
    return RGBA(255, 145, 0, 1);
}


+(UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
