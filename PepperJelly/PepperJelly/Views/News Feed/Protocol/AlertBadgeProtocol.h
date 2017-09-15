//
//  AlertBadgeProtocol.h
//  PepperJelly
//
//  Created by Sean McCue on 7/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AlertBadgeDelegate <NSObject>
@required
-(void)userPressedBadge;
@end
