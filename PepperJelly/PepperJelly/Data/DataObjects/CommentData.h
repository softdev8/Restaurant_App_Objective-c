//
//  CommentsData.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/21/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentData : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *dishId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *timeStamp;

@end
