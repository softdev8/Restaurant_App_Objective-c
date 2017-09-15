//
//  DesignableButton.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/23/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "DesignableButton.h"

@implementation DesignableButton

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(void)setBottomBorderColor:(UIColor *)bottomBorderColor{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - self.bottomBorderWidth, self.frame.size.width, self.bottomBorderWidth);
    bottomBorder.backgroundColor = self.bottomBorderColor.CGColor;
    [self.layer addSublayer:bottomBorder];
}

-(void)setInvertImageText:(BOOL)invertImageText{
    if(invertImageText) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0., self.frame.size.width - (self.imageView.image.size.width + 15.), 0., 0.);
        self.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., self.imageView.image.size.width);
    }
}

@end
