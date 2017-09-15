//
//  UISearchBar+Custom.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/4/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "UISearchBar+Custom.h"

@implementation UISearchBar (Custom)

-(void)searchBarCancelButtonTitle:(NSString*)title{
    UIButton *cancelButton;
    UIView *topView = self.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        [cancelButton setTitle:title forState:UIControlStateNormal];
    }
}

@end
