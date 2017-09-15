//
//  Search.m
//  PepperJelly
//
//  Created by Matt Frost on 4/11/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "Search.h"

@implementation Search

-(void)setRangeWithSliderOption:(DistanceSliderOption)option{
    switch (option) {
        case DistanceSliderOption1:
            self.range = [NSNumber numberWithInt:DISTANCE_SLIDER_VALUE_1];
            break;
        case DistanceSliderOption2:
            self.range = [NSNumber numberWithInt:DISTANCE_SLIDER_VALUE_2];
            break;
        case DistanceSliderOption3:
            self.range = [NSNumber numberWithInt:DISTANCE_SLIDER_VALUE_3];
            break;
        case DistanceSliderOption4:
            self.range = [NSNumber numberWithInt:DISTANCE_SLIDER_VALUE_4];
            break;
        case DistanceSliderOption5:
            self.range = [NSNumber numberWithInt:MAX_RANGE];
            break;
    }
}

@end
