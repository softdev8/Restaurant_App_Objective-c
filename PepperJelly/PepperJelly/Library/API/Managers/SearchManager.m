//
//  SearchManager.m
//  GalPal
//
//  Created by Sean McCue on 11/18/15.
//  Refactored by Carlos Alcala on 02/23/16.
//  Copyright © 2016 DogTown Media. All rights reserved.
//

#import "SearchManager.h"

@implementation SearchManager

//singleton
+ (instancetype)searchManager{
    static SearchManager * searchManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        searchManager = [[self alloc] init];
    });
    
    return searchManager;
}

-(void)searchForMatch:(NSString *)searchTerm andCompletionHandler:(void (^)(NSMutableArray *))completionHandler{

    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    /* check for and replace spaces in search term */
    searchTerm = [searchTerm stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *str = [NSString stringWithFormat:(@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&&types=&key=%@"), searchTerm, GOOGLE_API_KEY];
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"311ce480-3c82-cab9-c223-34cf805b17a1"};
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    /* Handle errors parsing if any */
                                                    NSError *parsingError = nil;
                                                    
                                                    if(data != nil){
                                                        /* Parse search results JSON into object */
                                                        id searchResults = [NSJSONSerialization
                                                                            JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                            error:&parsingError];
                                                        if(searchResults != nil){
                                                            NSArray  *array = [NSArray arrayWithObject:[searchResults objectForKey:@"predictions"]];
                                                            NSLog(@"array: %@", array);
                                                            if(array != nil && array.count > 0){
                                                                NSDictionary *locDic = [array objectAtIndex:0];
                                                                NSArray *add = [locDic valueForKey:@"terms"];
                                                                for(NSDictionary * str in add){
                                                                    NSArray *newStr = [str valueForKey:@"value"];
                                                                    switch (newStr.count) {
                                                                        case 0:
                                                                            return;
                                                                            break;
                                                                        case 1:
                                                                            [dataArray addObject:newStr[0]];
                                                                             break;
                                                                        default:{
                                                                            NSString *city = newStr[0];
                                                                            NSString *state = newStr[1];
                                                                            [dataArray addObject:[NSString stringWithFormat:@"%@, %@", city, state]];
                                                                            break;
                                                                        }
                                                                    }
                                                               }
                                                                
                                                                /* Pass search results back to caller */
                                                                completionHandler(dataArray);
                                                                
                                                                self.userSetCustomLocation = YES;
                                                                
                                                            }
                                                        }
                                                        
                                                    }
                                                }];
    [dataTask resume];
}

-(void)geocodeFromAddressString:(NSString *)address andCompletionHandler:(void (^)(CLLocation *))completionHandler{
    NSLog(@"address: %@", address);
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country", address];
    
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSDictionary *headers = @{@"cache-control": @"no-cache",
                              @"postman-token": GOOGLE_API_KEY
/*"4c857db3-09f7-f4b7-335f-50259c08517c"*/ };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"Geocode Error%@", error);
                                                    } else {
                                                        /* Handle errors parsing if any */
                                                        NSError *parsingError = nil;
                                                        
                                                        if(data != nil){
                                                            /* Parse search results JSON into object */
                                                            NSDictionary *searchResults = [NSJSONSerialization
                                                                                           JSONObjectWithData:data
                                                                                           options:NSJSONReadingMutableContainers
                                                                                           error:&parsingError];
                                                            if(searchResults.count > 0){
                                                                
                                                                NSArray *addData = [searchResults objectForKey:@"results"];
                                                          
                                                                
                                                                NSDictionary *Geo = [addData objectAtIndex:0];
                                                                NSDictionary *test = [Geo objectForKey:@"geometry"];
                                                                NSDictionary *location = [test objectForKey:@"location"];
      
                                                                float lat = [[location objectForKey:@"lat"] floatValue];
                                                                float lng = [[location objectForKey:@"lng"] floatValue];
              
                                                                CLLocation *cl = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
                                                                
                                                                /* Return CLLocation from long and lat */
                                                                completionHandler(cl);
                                                                
                                                            }
                                                            
                                                        }
                                                    }
                                                    
                                                }];
    [dataTask resume];
}


- (void)reverseGeocodeByLocation:(CLLocation *)location andCompletionHandler:(void (^)(NSString *, NSError *))completionHandler{
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if( placemarks ) {
            
            CLPlacemark *pm = [placemarks objectAtIndex:0];
            
            //NSLog(@"ADDRESS DICT: %@", pm.addressDictionary);
            
            NSString* city = [pm.addressDictionary objectForKey:@"City"];
            NSString* state = [pm.addressDictionary objectForKey:@"State"];
            NSString* zip = [pm.addressDictionary objectForKey:@"ZIP"];
            
            NSLog(@"CITY: %@", city);
            NSLog(@"STATE: %@", state);
            NSLog(@"ZIP: %@", zip);
            
            //construct address string for our API call and save information to ivars
            NSString *addressReverse = city;
            if(state)
                addressReverse = [addressReverse stringByAppendingFormat:@", %@", state];
            
            NSLog(@"ADDRESS: %@", addressReverse);
            
            completionHandler(addressReverse, nil);
            
            
        } else {
            NSError* error = [NSError errorWithDomain:@"com.dogtownmedia.GalPal.Error" code:1001 userInfo:@{ NSLocalizedDescriptionKey : @"Address Not Found"}];
            completionHandler(nil, error);
        }
    }];
}


@end
