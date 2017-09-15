//
//  DesignableButton.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/23/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DesignableButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat bottomBorderWidth;
@property (nonatomic, assign) IBInspectable UIColor *bottomBorderColor;
@property (nonatomic, assign) IBInspectable BOOL invertImageText;

@end
