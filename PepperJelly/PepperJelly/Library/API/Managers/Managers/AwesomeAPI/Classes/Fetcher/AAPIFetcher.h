//
//  AAPIFetcher.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAPIFetcher : NSObject

+(NSURLSessionDataTask*)fetchDataFromURLString:(NSString *)urlString completion:(void (^)(NSData *data))completion;
+(void)fetchDataFromURLString:(NSString *)urlString timeout:(double)timeout completion:(void (^)(BOOL success, NSData *data))completion;

@end
