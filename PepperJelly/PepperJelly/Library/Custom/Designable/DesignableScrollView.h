//
//  DesignableScrollView.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/10/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface DesignableScrollView : UIScrollView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end
