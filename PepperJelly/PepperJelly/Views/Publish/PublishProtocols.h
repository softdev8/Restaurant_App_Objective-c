//
//  PublishProtocols.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/14/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#ifndef PublishProtocols_h
#define PublishProtocols_h

@protocol PublishDelegate <NSObject>

-(void)selectImageFromGallery:(UIImage*)image;
-(void)selectImageFromCamera:(UIImage*)image;
-(void)canceledFromCamera;

@end

#endif /* PublishProtocols_h */
