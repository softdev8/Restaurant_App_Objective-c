//
//  AAPIParser.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "AAPIParser.h"

@implementation AAPIParser

+(NSDictionary*)jsonWithData:(NSData*)data{
    NSError *error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(error){
        NSLog(@"error serializing JSON: %@", error);
        return nil;
    }
    
    return json;
}

+(NSNumber*)doubleValueWithJSONObject:(NSDictionary*)object key:(NSString*)key{
    if([[object valueForKey:key] isKindOfClass:[NSString class]]){
        return [NSNumber numberWithDouble:[[object valueForKey:key] doubleValue]];
    }
    
    return [NSNumber numberWithDouble:[[[object valueForKey:key] objectAtIndex:0] doubleValue]];
}

+(NSString*)stringValueWithJSONObject:(NSDictionary*)object key:(NSString*)key{
    if([[object valueForKey:key] isKindOfClass:[NSString class]]){
        return [object valueForKey:key];
    }
    
    return [[object valueForKey:key] objectAtIndex:0];
}

@end
