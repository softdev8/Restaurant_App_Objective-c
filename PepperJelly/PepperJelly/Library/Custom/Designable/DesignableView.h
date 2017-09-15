//
//  DesignableView.h
//  OnDemand
//
//  Created by Evandro Harrison Hoffmann on 03/08/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DesignableView : UIView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

@end
