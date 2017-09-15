//
//  DesignableLabel.m
//  PepperJelly
//
//  Created by Sean McCue on 4/22/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "DesignableLabel.h"

@implementation DesignableLabel{
    UIEdgeInsets *insets;
}


- (void) drawTextInRect:(CGRect)rect
{
    UIEdgeInsets inset = {self.insetY,self.insetX,self.insetY,self.insetX};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, inset)];
}

@end
