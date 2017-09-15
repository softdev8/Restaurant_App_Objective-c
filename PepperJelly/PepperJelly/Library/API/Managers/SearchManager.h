//
//  SearchManager.h
//  GalPal
//
//  Created by Sean McCue on 11/18/15.
//  Refactored by Carlos Alcala on 02/23/16.
//  Copyright © 2016 DogTown Media. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

#define GOOGLE_API_KEY @"AIzaSyBXad2diFiK9rQw__TXxvoY5YCZRthgxCc"


@interface SearchManager : NSObject

@property(nonatomic) BOOL userSetCustomLocation;


+ (instancetype)searchManager;

-(void)searchForMatch:(NSString *)searchTerm andCompletionHandler:(void(^)(NSMutableArray *resultsArray))completionHandler;
-(void)geocodeFromAddressString:(NSString *)address andCompletionHandler:(void(^)(CLLocation *location))completionHandler;
-(void)reverseGeocodeByLocation:(CLLocation *)location andCompletionHandler:(void(^)(NSString *address, NSError *error))completionHandler;

@end


