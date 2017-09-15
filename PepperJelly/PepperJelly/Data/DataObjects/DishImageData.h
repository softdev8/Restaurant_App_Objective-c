//
//  DishImage.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DishImageData : NSObject

@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSNumber* width;
@property (nonatomic, strong) NSNumber* height;

-(id)initWithUrl:(NSString*)url width:(double)width height:(double)height;
-(id)initWithUrl:(NSString*)url size:(CGSize)size;

@end
