//
//  EmptyMessageView.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "EmptyMessageView.h"

@implementation EmptyMessageView

+(EmptyMessageView*)emptyMessageView{
    return [[[NSBundle bundleForClass:self] loadNibNamed:@"EmptyMessageView" owner:self options:nil] objectAtIndex:0];
}

-(void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = true;
}

-(void)show{    
    self.hidden = false;
    self.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    }];
}

-(void)hide{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)actionButtonPressed:(UIButton *)sender {
    [self.delegate didPressEmptyMessageActionButtonWithText:sender.titleLabel.text];
}

@end
