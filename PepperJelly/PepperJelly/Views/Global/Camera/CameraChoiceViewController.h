//
//  CameraChoiceViewController.h
//  Tribelook
//
//  Created by Evandro Harrison Hoffmann on 3/18/16.
//  Copyright © 2016 gary brook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CameraOptions) {
    CameraOptionCamera,
    CameraOptionLibrary
};

@protocol CameraChoiceDelegate <NSObject>
@optional
-(void)cameraOptionSelected:(CameraOptions)option;
@end

@interface CameraChoiceViewController : UIViewController

@property (weak, nonatomic) id<CameraChoiceDelegate> delegate;

@end
