//
//  ImageCollectionViewController.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/25/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol ImageCollectionDelegate <NSObject>

-(void)collectionSelected:(PHAssetCollection*)collection;

@end

@interface ImageCollectionViewController : UIViewController

@property (nonatomic, weak) id<ImageCollectionDelegate> delegate;

@end
