//
//  APIManager.h
//  DTM API BASE
//
//  Created by Matt Frost on 12/30/15.
//  Copyright © 2015 Dogtown Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFURLSessionManager;


@interface APIRequestManager : NSObject
{
    NSURLSessionConfiguration *_configuration;
    AFURLSessionManager *_manager;
}

+ (APIRequestManager *)sharedInstance;

/********************
 
GET Requests
 
Options for providing a response class class and authorization header.
********************/


-(void)GET:(Class)objClass withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass  completion:(void (^)(BOOL success, id obj))completion;

-(void)GETCollectionOfClass:(Class)objClass withURL:(NSString *)url andAuthorization:(NSString *)authToken completion:(void (^)(BOOL success, id obj))completion;
-(void)GETwithURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass  completion:(void (^)(BOOL success, id obj))completion;
/********************
 
 POST Requests
 
 Options for providing a response class if differing from the posted object,
 authorization header token, and an array of parameters to ignore if an object contains a property that doesnt need to be sent.
********************/


-(void)POST:(id)obj withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass ignoringParams:(NSArray *)ignored completion:(void (^)(BOOL success, id obj))completion;
-(void)POSTDic:(NSDictionary*)params withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass completion:(void (^)(BOOL success, id obj))completion;

-(void)POSTCollectionOfClass:(Class)objClass collection:(NSMutableArray *)collection withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass ignoringParams:(NSArray *)ignored completion:(void (^)(BOOL success, id obj))completion;

+(NSDictionary*)dictionaryWithObject:(id)obj ignoringParams:(NSArray*)ignored;

/********************
 
 DELETE Requests
 
 This will complete a DELETE request where the params need to be in the URI like DELETE http://api.com/?user=1234

 ********************/

-(void)DELETE:(id)obj withURL:(NSString *)url andAuthorization:(NSString *)authToken responseClass:(Class)responseClass ignoringParams:(NSArray *)ignored completion:(void (^)(BOOL success, id obj))completion;

@end
