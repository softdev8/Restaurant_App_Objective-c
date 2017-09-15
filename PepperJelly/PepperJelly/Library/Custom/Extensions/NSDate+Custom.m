//
//  NSDate+Custom.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/24/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

+(NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateString];
}

+(NSString*)dateToString:(NSDate*)date format:(NSString*)format{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}


#pragma mark - Class Functions

-(NSString*)dateToStringWithFormat:(NSString*)format{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

@end
