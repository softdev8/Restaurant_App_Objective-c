//
//  APIManager.m
//  DTM API BASE
//
//  Created by Matt Frost on 12/30/15.
//  Copyright © 2015 Dogtown Media. All rights reserved.
//

#import "APIRequestManager.h"
#import "APIDataFormatter.h"
#import "AFNetworking.h"

@implementation APIRequestManager

+ (APIRequestManager *)sharedInstance {
    
    static APIRequestManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[APIRequestManager alloc] init];
        _sharedInstance->_configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sharedInstance->_manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:_sharedInstance->_configuration];
        [_sharedInstance setupReachabilityMonitor];
        
    });
    
    return _sharedInstance;
}

-(void)setupReachabilityMonitor{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSDictionary *info = [NSDictionary dictionaryWithObject:AFStringFromNetworkReachabilityStatus(status)forKey:@"APIStatus"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APIReachabilityNotification" object:self userInfo:info];
    }];
}

-(void)GET:(Class)objClass withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass  completion:(void (^)(BOOL success, id obj))completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if(authToken){
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        
    }
    
    NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
       
//        NSLog(@"DEBUG RESPONSE: %@",response);
//        NSLog(@"DEBUG RESPONSE OBJ: %@",responseObject);
//        NSLog(@"DEBUG RESPONSE ERROR: %@",error);

        id obj;
        if (responseClass) {
            obj = [[responseClass alloc] init];
            
        } else {
            obj = [[objClass alloc] init];
            
        }
        [(NSDictionary *)responseObject enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([ objClass instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        if (error) {
            completion(NO,obj);
        } else {
            completion(YES,obj);
        }
    }];
    [dataTask resume];
}

-(void)GETwithURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass  completion:(void (^)(BOOL success, id obj))completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if(authToken){
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        
    }
    
    NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        //NSLog(@"DEBUG RESPONSE: %@",response);
        //NSLog(@"DEBUG RESPONSE OBJ: %@",responseObject);
        //NSLog(@"DEBUG RESPONSE ERROR: %@",error);
        
        id obj;
        if (responseClass) {
            obj = [[responseClass alloc] init];
            
        } else {
            obj = [[[obj class] alloc] init];
            
        }
        
        [(NSDictionary *)responseObject enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([ [obj class] instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        
        if (error) {
            completion(NO,obj);
        } else {
            completion(YES,obj);
        }

    }];
    [dataTask resume];
}



-(void)GETCollectionOfClass:(Class)objClass withURL:(NSString *)url andAuthorization:(NSString *)authToken completion:(void (^)(BOOL success, id obj))completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if(authToken){
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        
    }
    
    NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSMutableArray *objectCollection = [[NSMutableArray alloc] initWithArray:responseObject];
        NSMutableArray *responseCollection = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < objectCollection.count; i++) {
            
            NSMutableDictionary *objectDict = [objectCollection objectAtIndex:i];
            id obj = [[objClass alloc] init];

            [objectDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                if ([ objClass instancesRespondToSelector:NSSelectorFromString(key)]) {
                    [obj setValue:value forKey:key];
                }
            }];
            [responseCollection addObject:obj];
            
        }
        if (error) {
            completion(NO,responseCollection);
        } else {
            completion(YES,responseCollection);
        }
    }];
    [dataTask resume];
}

-(void)POST:(id)obj withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass ignoringParams:(NSArray *)ignored completion:(void (^)(BOOL success, id obj))completion{
    [self POSTDic:[APIRequestManager dictionaryWithObject:obj ignoringParams:ignored] withURL:url andAuthorization:authToken responseClass:responseClass completion:completion];
}


-(void)POSTDic:(NSDictionary*)params withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass completion:(void (^)(BOOL success, id obj))completion{
    
    NSLog(@"URL%@\n PARAMS: %@", url, params);
    
    NSMutableURLRequest *request= [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    
    if(authToken){
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        
    }
    
    NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //NSLog(@"DEBUG RESPONSE: %@",response);
            //NSLog(@"DEBUG RESPONSE OBJ: %@",responseObject);
            //NSLog(@"DEBUG RESPONSE ERROR: %@",error);
            id obj;
            if (responseClass) {
                obj = [[responseClass alloc] init];
                
            } else {
                obj = [[[obj class] alloc] init];
                
            }
            [(NSDictionary *)responseObject enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                if ([ [obj class] instancesRespondToSelector:NSSelectorFromString(key)]) {
                    [obj setValue:value forKey:key];
                }
            }];
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   completion(NO,obj);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES,obj);
                });
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [dataTask resume];
    });
    
    
}

-(void) POSTCollectionOfClass:(Class)objClass collection:(NSMutableArray *)collection withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass ignoringParams:(NSArray *)ignored completion:(void (^)(BOOL, id))completion{
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    NSDictionary *dict =[APIDataFormatter propertiesOfClass:[objClass class]];
    
    for (id obj in collection) {
        NSMutableDictionary *objectParams = [[NSMutableDictionary alloc] init];

        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([(NSString*)value isEqualToString:@"NSMutableArray"] || [(NSString*)value isEqualToString:@"NSArray"]) {
                
                id testArray = [obj valueForKey:key];
                
                if (testArray == NULL) {
                } else {
                    
                    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:testArray];
                    NSMutableArray *secondary = [[NSMutableArray alloc] init];
                    
                    if (temp.count > 0) {
                        id test = [obj valueForKey:key][0];
                        
                        
                        if ([test superclass] == [NSString class] || [[test superclass]isSubclassOfClass:[NSString class]]) {
                            if ([obj valueForKey:key])
                                [objectParams setObject:[obj valueForKey:key] forKey:key];
                        }
                        else {
                            for (int i = 0; i < temp.count; i++) {
                                id test = [obj valueForKey:key][i];
                                NSDictionary *secondTier = [APIDataFormatter propertiesOfSubclass:[test class]];
                                
                                NSMutableDictionary *secondTierParams = [[NSMutableDictionary alloc] init];
                                [secondTier enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                                    if ([test valueForKey:key])
                                        [secondTierParams setObject:[test valueForKey:key] forKey:key];
                                }];
                                [secondary addObject:secondTierParams];
                                
                            }
                            [objectParams setObject:secondary forKey:key];
                        }
                    }
                }
                
            }else{
                if ([obj valueForKey:key])
                    [objectParams setObject:[obj valueForKey:key] forKey:key];
            }
        }];
        if (ignored && [ignored count] > 0) {
            for (NSString *key in ignored) {
                [objectParams removeObjectForKey:key];
            }
        }
        [params addObject:objectParams];
    }
    
    
    NSMutableURLRequest *request= [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    
    if(authToken){
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        
    }
    
    NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

        NSMutableArray *objectCollection = [[NSMutableArray alloc] initWithArray:responseObject];
        NSMutableArray *responseCollection = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < objectCollection.count; i++) {
            
            NSMutableDictionary *objectDict = [objectCollection objectAtIndex:i];
            id obj = [[responseClass alloc] init];

            if (responseClass) {
                obj = [[responseClass alloc] init];
                [objectDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                    if ([ responseClass instancesRespondToSelector:NSSelectorFromString(key)]) {
                        [obj setValue:value forKey:key];
                    }
                }];
            } else {
                obj = [[[objClass class] alloc] init];
                [objectDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                    if ([ objClass instancesRespondToSelector:NSSelectorFromString(key)]) {
                        [obj setValue:value forKey:key];
                    }
                }];
            }
            [responseCollection addObject:obj];
        }

        
        if (error) {
            completion(NO,responseCollection);
        } else {
            completion(YES,responseCollection);
        }
        
    }];
    [dataTask resume];

}

+(NSDictionary *)dictionaryWithObject:(id)obj ignoringParams:(NSArray *)ignored{
    NSDictionary *dict =[APIDataFormatter propertiesOfClass:[obj class]];
    
    //NSLog(@"DICT: %@", dict);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
        if ([(NSString*)value isEqualToString:@"NSMutableArray"] || [(NSString*)value isEqualToString:@"NSArray"]) {
            
            id testArray = [obj valueForKey:key];
            
            if (testArray == NULL) {
                //FIXED: avoid crashes and do nothing wit null test array
            } else {
                
                //handle NSArray param items
                NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:testArray];
                NSMutableArray *secondary = [[NSMutableArray alloc] init];
                
                if ([temp respondsToSelector:@selector(count)] || temp.count > 0) {
                    
                    id test;
                    
                    if(temp.count > 0){
                        test = [obj valueForKey:key][0];
                    }
                    else{
                        test = @"";
                        
                    }
                    if ([test superclass] == [NSString class] || [[test superclass]isSubclassOfClass:[NSString class]]) {
                        if ([obj valueForKey:key])
                            [params setObject:[obj valueForKey:key] forKey:key];
                    }
                    else {
                        for (int i = 0; i < temp.count; i++) {
                            id test = [obj valueForKey:key][i];
                            NSDictionary *secondTier = [APIDataFormatter propertiesOfSubclass:[test class]];
                            
                            NSMutableDictionary *secondTierParams = [[NSMutableDictionary alloc] init];
                            [secondTier enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                                if ([test valueForKey:key])
                                    [secondTierParams setObject:[test valueForKey:key] forKey:key];
                            }];
                            [secondary addObject:secondTierParams];
                            
                        }
                        [params setObject:secondary forKey:key];
                    }
                }
            }
            
        }else{
            if ([obj valueForKey:key])
                [params setObject:[obj valueForKey:key] forKey:key];
        }
    }];
    
    if (ignored && [ignored count] > 0) {
        for (NSString *key in ignored) {
            [params removeObjectForKey:key];
            
        }
    }
    
    NSLog(@"PARAMS: %@", params);
    
    return params;
}

-(void)DELETE:(id)obj withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass ignoringParams:(NSArray *)ignored completion:(void (^)(BOOL success, id obj))completion{
    NSDictionary *dict =[APIDataFormatter propertiesOfClass:[obj class]];
    
    //NSLog(@"DICT: %@", dict);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
        if ([(NSString*)value isEqualToString:@"NSMutableArray"] || [(NSString*)value isEqualToString:@"NSArray"]) {
            
            id testArray = [obj valueForKey:key];
            
            if (testArray == NULL) {
                //FIXED: avoid crashes and do nothing wit null test array
            } else {
                
                //handle NSArray param items
                NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:testArray];
                NSMutableArray *secondary = [[NSMutableArray alloc] init];
                
                if (temp.count > 0) {
                    id test = [obj valueForKey:key][0];
                    
                    
                    if ([test superclass] == [NSString class] || [[test superclass]isSubclassOfClass:[NSString class]]) {
                        if ([obj valueForKey:key])
                            [params setObject:[obj valueForKey:key] forKey:key];
                    }
                    else {
                        for (int i = 0; i < temp.count; i++) {
                            id test = [obj valueForKey:key][i];
                            NSDictionary *secondTier = [APIDataFormatter propertiesOfSubclass:[test class]];
                            
                            NSMutableDictionary *secondTierParams = [[NSMutableDictionary alloc] init];
                            [secondTier enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
                                if ([test valueForKey:key])
                                    [secondTierParams setObject:[test valueForKey:key] forKey:key];
                            }];
                            [secondary addObject:secondTierParams];
                            
                        }
                        [params setObject:secondary forKey:key];
                    }
                }
            }
            
        }else{
            if ([obj valueForKey:key])
                [params setObject:[obj valueForKey:key] forKey:key];
        }
    }];
    
    if (ignored && [ignored count] > 0) {
        for (NSString *key in ignored) {
            [params removeObjectForKey:key];
            
        }
    }
    
    //NSLog(@"URL%@\n PARAMS: %@", url, params);
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    serializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET",@"HEAD", nil];
    NSMutableURLRequest *request= [serializer requestWithMethod:@"DELETE" URLString:url parameters:params error:nil];
    
    if(authToken){
        [request setValue:authToken forHTTPHeaderField:@"Authorization"];
        
    }
    
    NSURLSessionDataTask *dataTask = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSLog(@"DEBUG RESPONSE: %@",response);
//        NSLog(@"DEBUG RESPONSE OBJ: %@",responseObject);
//        NSLog(@"DEBUG RESPONSE ERROR: %@",error);
        id obj;
        if (responseClass) {
            obj = [[responseClass alloc] init];
            
        } else {
            obj = [[[obj class] alloc] init];
            
        }
        [(NSDictionary *)responseObject enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL* stop) {
            if ([ [obj class] instancesRespondToSelector:NSSelectorFromString(key)]) {
                [obj setValue:value forKey:key];
            }
        }];
        
        if (error) {
            completion(NO,obj);
        } else {
            completion(YES,obj);
        }
        
    }];
    [dataTask resume];
}
@end
