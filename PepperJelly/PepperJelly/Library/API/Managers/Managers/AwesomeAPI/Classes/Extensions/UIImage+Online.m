//
//  UIImage+Online.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/24/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "UIImage+Online.h"
#import "AAPIFetcher.h"

@implementation UIImage (Online)

+(NSURLSessionDataTask*)imageWithUrl:(NSString *)url completion:(void (^)(UIImage *image))completion{
    
    //return nil;
    
    NSURLSessionDataTask* task = [AAPIFetcher fetchDataFromURLString:url completion:^(NSData *data) {
        completion([UIImage imageWithData:data]);
    }];
    
    return task;
}

+(NSURLSessionDataTask*)imageWithUrl:(NSString *)url placeHolder:(UIImage*)placeholder completion:(void (^)(UIImage *image))completion{
    
    //return nil;
    
    if(!url || url.length == 0){
        completion(placeholder);
        return nil;
    }
    
    return [self imageWithUrl:url completion:^(UIImage *image) {
        if(image)
            completion(image);
        else
            completion(placeholder);
    }];
}

@end
