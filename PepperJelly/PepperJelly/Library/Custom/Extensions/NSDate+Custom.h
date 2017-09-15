//
//  NSDate+Custom.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/24/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Custom)

+(NSDate*)stringToDate:(NSString*)dateString format:(NSString*)format;
+(NSString*)dateToString:(NSDate*)date format:(NSString*)format;

-(NSString*)dateToStringWithFormat:(NSString*)format;

@end
