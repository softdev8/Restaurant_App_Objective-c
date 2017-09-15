//
//  DesignableTextView.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "DesignableTextView.h"

@implementation DesignableTextView

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

-(void)setInsetX:(CGFloat)insetX{
    self.textContainerInset = UIEdgeInsetsMake(self.insetY, insetX, self.insetY, insetX);
}

-(void)setInsetY:(CGFloat)insetY{
    self.textContainerInset = UIEdgeInsetsMake(insetY, self.insetX, insetY, self.insetX);
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

@end
