//
//  ReportMoreMenuViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/13/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "MoreMenuViewController.h"

@protocol ReportMoreMenuDelegate <NSObject>

-(void)reportDishWithDishId:(NSString*)dishId andWithReason:(NSString*)reason;
-(void)reportUserWithUserId:(NSString*)userId andWithReason:(NSString*)reason;
-(void)reportCanceled;

@end

@interface ReportMoreMenuViewController : MoreMenuViewController

@property (nonatomic, weak) id<ReportMoreMenuDelegate> reportDelegate;

@end
