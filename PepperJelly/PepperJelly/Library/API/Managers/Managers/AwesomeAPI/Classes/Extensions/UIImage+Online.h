//
//  UIImage+Online.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/24/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Online)

+(NSURLSessionDataTask*)imageWithUrl:(NSString *)url completion:(void (^)(UIImage *image))completion;
+(NSURLSessionDataTask*)imageWithUrl:(NSString *)url placeHolder:(UIImage*)placeholder completion:(void (^)(UIImage *image))completion;

@end
