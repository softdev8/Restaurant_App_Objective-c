//
//  EmptyMessageView.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignableButton.h"
#import "EmptyMessageProtocols.h"

@interface EmptyMessageView : UIView

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet DesignableButton *actionButton;

@property (nonatomic, weak) id<EmptyMessageDelegate> delegate;

+(EmptyMessageView*)emptyMessageView;

-(void)show;
-(void)hide;

@end
