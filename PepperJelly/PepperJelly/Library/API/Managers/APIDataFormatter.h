//
//  APIDataSerializer.h
//  DTM API BASE
//
//  Created by Matt Frost on 1/5/16.
//  Copyright © 2016 Dogtown Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIDataFormatter : NSObject
+ (NSDictionary *) propertiesOfObject:(id)object;
+ (NSDictionary *) propertiesOfClass:(Class)class;
+ (NSDictionary *) propertiesOfSubclass:(Class)class;
@end
