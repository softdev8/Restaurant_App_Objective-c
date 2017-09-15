//
//  DesignableTextView.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DesignableTextView : UITextView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat insetX;
@property (nonatomic, assign) IBInspectable CGFloat insetY;

@end
