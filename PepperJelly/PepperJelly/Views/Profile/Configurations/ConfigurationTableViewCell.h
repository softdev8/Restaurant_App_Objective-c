//
//  ConfigurationTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 MobileDev418. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfigurationDelegate <NSObject>

@optional
-(void)textFieldContentDidChange:(NSString*)content index:(NSIndexPath*)indexPath;
-(void)textViewContentDidChange:(NSString*)content index:(NSIndexPath*)indexPath;
-(void)switchDidChange:(BOOL)switchValue index:(NSIndexPath*)indexPath;

@end

@interface ConfigurationTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<ConfigurationDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL disableSpaces;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrorImageView;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UISwitch *offlineSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;
@property (weak, nonatomic) IBOutlet UITextView *userBioTextView;


@end
