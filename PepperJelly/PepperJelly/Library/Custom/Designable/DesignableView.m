//
//  DesignableView.m
//  OnDemand
//
//  Created by Evandro Harrison Hoffmann on 03/08/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "DesignableView.h"

@implementation DesignableView

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}


@end
