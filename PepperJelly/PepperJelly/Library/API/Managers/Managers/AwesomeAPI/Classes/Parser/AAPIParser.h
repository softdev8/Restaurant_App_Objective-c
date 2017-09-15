//
//  AAPIParser.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAPIParser : NSObject

+(NSDictionary*)jsonWithData:(NSData*)data;
+(NSNumber*)doubleValueWithJSONObject:(NSDictionary*)object key:(NSString*)key;
+(NSString*)stringValueWithJSONObject:(NSDictionary*)object key:(NSString*)key;

@end
