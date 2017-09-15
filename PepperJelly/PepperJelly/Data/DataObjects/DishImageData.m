//
//  DishImage.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/5/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "DishImageData.h"

@implementation DishImageData

-(id)initWithUrl:(NSString *)url width:(double)width height:(double)height{
    self = [super init];
    if(self) {
        self.url = url;
        self.width = [NSNumber numberWithDouble:width];
        self.height = [NSNumber numberWithDouble:height];
    }
    return self;
}

-(id)initWithUrl:(NSString *)url size:(CGSize)size{
    self = [super init];
    if(self) {
        self.url = url;
        self.width = [NSNumber numberWithDouble:size.width];
        self.height = [NSNumber numberWithDouble:size.height];
    }
    return self;
}

@end
