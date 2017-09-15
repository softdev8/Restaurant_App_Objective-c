//
//  UIView+Loading.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "UIView+Loading.h"
#import "LoadingView.h"
#import "EmptyMessageView.h"
@import MBProgressHUD;

@implementation UIView (Loading)

-(void)startLoading{
    [self stopLoading];
    [self hideMessage];
    
    LoadingView *loadingView = [LoadingView loadingView];
    loadingView.alpha = 0.0;
    loadingView.frame = self.bounds;
    
    if(loadingView.frame.size.width < loadingView.activityView.frame.size.width*2)
        loadingView.loadingScale = loadingView.frame.size.width/(loadingView.activityView.frame.size.width*2);
    
    [self addSubview:loadingView];
    [loadingView startAnimating];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

-(void)startLoadingAfterDelay:(CGFloat)delay{
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(startLoading) userInfo:nil repeats:NO];
}

-(void)stopLoading{
    for(int i = (int)self.subviews.count-1; i >= 0; i-- ){
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[LoadingView class]]){
            [[self.subviews objectAtIndex:i] stopAnimating];
            //break;
        } else if ([[self.subviews objectAtIndex:i] isKindOfClass:[MBProgressHUD class]]) {
            __block MBProgressHUD *hud = (MBProgressHUD *)[self.subviews objectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }
    }
}

-(BOOL)isLoading{
    for(int i = (int)self.subviews.count-1; i >= 0; i-- ){
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[LoadingView class]]){
            if([[self.subviews objectAtIndex:i] animating])
                return true;
        }
    }
    return false;
}

-(void)showMessageWithText:(NSString *)text{
    [self hideMessage];
    
    if([self isLoading])
        return;
    
    EmptyMessageView *emptyMessageView = [EmptyMessageView emptyMessageView];
    emptyMessageView.frame = self.bounds;
    
    emptyMessageView.messageTextView.text = text;
    [emptyMessageView.messageTextView sizeToFit];
    
    emptyMessageView.actionButton.hidden = YES;
    
    [self addSubview:emptyMessageView];
    [emptyMessageView show];
}

-(void)showMessageWithText:(NSString *)text actionTitle:(NSString *)actionTitle delegate:(id)delegate{
    [self hideMessage];
    
    if([self isLoading])
        return;
    
    EmptyMessageView *emptyMessageView = [EmptyMessageView emptyMessageView];
    emptyMessageView.frame = self.bounds;
    
    emptyMessageView.messageTextView.text = text;
    [emptyMessageView.messageTextView sizeToFit];
    
    [emptyMessageView.actionButton setTitle:actionTitle forState:UIControlStateNormal];
    emptyMessageView.delegate = delegate;
    
    [self addSubview:emptyMessageView];
    [emptyMessageView show];
}

-(void)hideMessage{
    for(int i = (int)self.subviews.count-1; i >= 0; i-- ){
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[EmptyMessageView class]]){
            [[self.subviews objectAtIndex:i] hide];
        }
    }
}

@end
