//
//  SearchProtocols.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/17/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#ifndef SearchProtocols_h
#define SearchProtocols_h

#import "Restaurant.h"
#import "User.h"

@protocol SearchDelegate <NSObject>

-(void)openRestaurant:(Restaurant*)restaurant;
-(void)openUser:(User*)user;

@end


#endif /* SearchProtocols_h */
