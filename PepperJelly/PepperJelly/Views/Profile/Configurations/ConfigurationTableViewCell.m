//
//  ConfigurationTableViewCell.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 MobileDev418. All rights reserved.
//

#import "ConfigurationTableViewCell.h"

@implementation ConfigurationTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.descTextField.delegate = self;
    self.userBioTextView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    [self.offlineSwitch setOn:!self.offlineSwitch.on animated:TRUE];
//    [self switchPressed:self.offlineSwitch];
}

#pragma mark - Events

- (IBAction)switchPressed:(id)sender {
    [self.delegate switchDidChange:self.offlineSwitch.isOn index:self.indexPath];
}

- (IBAction)pushSwitchPressed:(id)sender {
    [self.delegate switchDidChange:self.pushSwitch.isOn index:self.indexPath];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.descTextField resignFirstResponder];
    [self.delegate textFieldContentDidChange:self.descTextField.text index:self.indexPath];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(self.disableSpaces){
        if([string isEqualToString:@" "])
            return NO;
    }
    return YES;
}

- (IBAction)updateUserBIO:(id)sender {
    [self.userBioTextView resignFirstResponder];
    [self.delegate textViewContentDidChange:self.userBioTextView.text index:self.indexPath];

}


@end
