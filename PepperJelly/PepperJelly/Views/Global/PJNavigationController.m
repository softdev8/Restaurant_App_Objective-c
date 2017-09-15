//
//  PJNavigationController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PJNavigationController.h"
#import "UIColor+PepperJelly.h"
#import "Constants.h"

@interface PJNavigationController ()

@end

@implementation PJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the background and shadow image to get rid of the line.
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self.navigationBar setBackgroundImage:[UIColor imageFromColor:[UIColor navigationBarColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.navigationBar.tintColor = [UIColor navigationBarItemColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor navigationTitleColor], NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    
    if([UIBarButtonItem respondsToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)]){
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObjects:[UINavigationBar class], nil]] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor pepperjellyPinkColor], NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:13.0f]} forState:UIControlStateNormal];
    }else{
        if([UIBarButtonItem respondsToSelector:@selector(appearanceWhenContainedIn:)]){
            [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor pepperjellyPinkColor], NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:13.0f]} forState:UIControlStateNormal];
        }
    }
}

@end
