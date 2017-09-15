//
//  DesignableTextField.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/31/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "DesignableTextField.h"

@implementation DesignableTextField

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , self.insetX , self.insetY);
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , self.insetX , self.insetY);
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

@end
