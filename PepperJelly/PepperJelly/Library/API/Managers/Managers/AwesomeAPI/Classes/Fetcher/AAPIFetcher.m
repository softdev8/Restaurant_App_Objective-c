//
//  AAPIFetcher.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/9/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "AAPIFetcher.h"

@implementation AAPIFetcher

+(NSURLSessionDataTask*)fetchDataFromURLString:(NSString *)urlString completion:(void (^)(NSData *data))completion{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error){
                NSLog(@"There was an error... %@", error);
                completion(nil);
            }else{
                completion(data);
            }
        });
    }];
    [task resume];
    
    return task;
}

+(void)fetchDataFromURLString:(NSString *)urlString timeout:(double)timeout completion:(void (^)(BOOL success, NSData *data))completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block BOOL canTimeOut = true;
        __block BOOL timedOut = false;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (canTimeOut) {
                timedOut = true;
                completion(false, nil);
            }
        });
        
        [self fetchDataFromURLString:urlString completion:^(NSData *data) {
            canTimeOut = false;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data){
                    if (!timedOut){
                        completion(true, data);
                    }
                }else{
                    if(!timedOut){
                        completion(false, nil);
                    }
                }
            });
        }];
    });
}

@end
