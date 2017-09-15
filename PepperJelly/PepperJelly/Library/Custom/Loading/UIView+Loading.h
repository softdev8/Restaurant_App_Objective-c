//
//  UIView+Loading.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyMessageProtocols.h"

@interface UIView (Loading)

-(void)startLoading;
-(void)startLoadingAfterDelay:(CGFloat)delay;
-(void)stopLoading;
-(BOOL)isLoading;

-(void)showMessageWithText:(NSString*)text;
-(void)showMessageWithText:(NSString*)text actionTitle:(NSString*)actionTitle delegate:(id)delegate;
-(void)hideMessage;
@end
