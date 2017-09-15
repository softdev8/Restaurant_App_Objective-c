//
//  EmptyMessageProtocols.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmptyMessageDelegate <NSObject>

-(void)didPressEmptyMessageActionButtonWithText:(NSString *)text;

@end
