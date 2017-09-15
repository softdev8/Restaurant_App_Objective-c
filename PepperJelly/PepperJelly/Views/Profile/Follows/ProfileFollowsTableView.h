//
//  ProfileFollowsViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/8/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileProtocols.h"

@interface ProfileFollowsTableView : UITableView

@property (nonatomic, weak) id<ProfileDelegate> profileDelegate;

-(void)updateWithList:(NSArray*)list;
-(void)reload;

@end
