//
//  ConfigurationsViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/7/16.
//  Copyright © 2016 MobileDev418. All rights reserved.
//

#import "ConfigurationsViewController.h"
#import "APIManager.h"
#import "DesignableButton.h"
#import "ConfigurationTableViewCell.h"
#import "UIView+Loading.h"
#import "CameraChoiceViewController.h"
#import "TermsViewController.h"
#import <MessageUI/MessageUI.h>
#import "Constants.h"
#import "UIImage+Cropping.h"

@interface ConfigurationsViewController () <ConfigurationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraChoiceDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet DesignableButton *logoutButton;

@end

@implementation ConfigurationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[CameraChoiceViewController class]]){
        ((CameraChoiceViewController*)segue.destinationViewController).delegate = self;
    }else if([segue.destinationViewController isKindOfClass:[TermsViewController class]]){
        if([segue.identifier isEqualToString:@"termsSegue"]){
            ((TermsViewController*)segue.destinationViewController).name = NSLocalizedString(@"termsofuse", @"");
            ((TermsViewController*)segue.destinationViewController).file = @"termsOfUse";
        }else if([segue.identifier isEqualToString:@"privacySegue"]){
            ((TermsViewController*)segue.destinationViewController).name = NSLocalizedString(@"privacypolicy", @"");
            ((TermsViewController*)segue.destinationViewController).file = @"privacyPolicy";
        }else{
            ((TermsViewController*)segue.destinationViewController).name = NSLocalizedString(@"licenses", @"");
            ((TermsViewController*)segue.destinationViewController).file = @"licenses";
        }
    }
}

#pragma mark - Events
-(void)showEmail{
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc]init];
        mc.mailComposeDelegate = self;
        [mc setToRecipients:@[feedbackEmail]];
        [mc setSubject:NSLocalizedString(@"feedback_title", @"")];
        [mc setMessageBody:NSLocalizedString(@"feedback_message", @"") isHTML:NO];
        [self presentViewController:mc animated:YES completion:nil];
    }else{
        NSLog(NSLocalizedString(@"feedback_error", @""));
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)logoutButtonPressed:(id)sender {
    [APIManager.sharedInstance logoutUser];
    [self performSegueWithIdentifier:@"logoutSegue" sender:self];
}

-(void)uploadUserPhotos:(UIImage *)img{
    [self.view startLoadingAfterDelay:0.0];
    [[APIManager sharedInstance] userUploadPhoto:[UIImage squareImageWithImage:img scaledToSize:IMAGE_SIZE_PROFILE] completionHandler:^(BOOL success, NSString *url){
        if(success){
            
            UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
            user.pictures = [NSArray arrayWithObjects:url, nil];
            
            [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
                [self.view stopLoading];
                
                if(success){
                    [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_uploadimage", @"") viewController:self];
                }else{
                    [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_uploadimage_title", @"") message:response.error viewController:self];
                }
            }];
        }else{
            [self.view stopLoading];
            [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_uploadimage_title", @"") message:NSLocalizedString(@"error_failed_uploadimage", @"") viewController:self];
        }
    }];
}

-(void)removeUserPicture{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"profile_picture_errase_prompt", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *removeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"profile_picture_errase_remove", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        
        [self.view startLoading];
        UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
        user.pictures = [NSArray arrayWithObjects:@"", nil];
        
        [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
            [self.view stopLoading];
            
            if(success){
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_removeimage", @"") viewController:self];
            }else{
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_uploadimage_title", @"") message:response.error viewController:self];
            }
        }];
    }];
    [alertController addAction:removeAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"profile_picture_errase_cancel", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)changePassword:(NSString*)password{
    [self.view startLoading];
    [APIManager.sharedInstance changePassword:password completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        [self.tableView reloadData];
        
        if(success){
            if(response.result.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:response.result viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_passwordchanged", @"") viewController:self];
        }else{
            if(response.error.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:response.error viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}

-(void)changeFullName:(NSString*)fullName{
    [self.view startLoading];
    UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
    user.fullName = fullName;
    
    [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
       [self.view stopLoading];
        
        [self.tableView reloadData];
        
        if(success){
            if(response.result.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:response.result viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_fullnamechanged", @"") viewController:self];
        }else{
            if(response.error.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:response.error viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}

-(void)changeUsername:(NSString*)username{
    [self.view startLoading];
    UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
    user.userName = username;
    
    [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        [self.tableView reloadData];
        
        if(success){
            if(response.result.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:response.result viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_usernamechanged", @"") viewController:self];
        }else{
            if([response.SERVER_ERROR containsString:@"duplicate key error"])
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:NSLocalizedString(@"error_failed_changeusername", @"") viewController:self];
            else if(response.error.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:response.error viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}

-(void)changeUserBio:(NSString*)userbio{
    [self.view startLoading];
    UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
    user.userBio = userbio;
    
    [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {
        [self.view stopLoading];
        
        [self.tableView reloadData];
        
        if(success){
            if(response.result.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:response.result viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_userbiochanged", @"") viewController:self];
        }else{
            if([response.SERVER_ERROR containsString:@"duplicate key error"])
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:NSLocalizedString(@"error_failed_changeusername", @"") viewController:self];
            else if(response.error.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:response.error viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}

-(void)changeEmail:(NSString*)email{
    [self.view startLoading];
    
    UserModify *user = [[UserModify alloc] initWithUser:[APIManager sharedInstance].user];
    user.email = email;
    
    [[APIManager sharedInstance] modifyUser:user completion:^(BOOL success, APIResponse *response) {[self.view stopLoading];
        
        [self.tableView reloadData];
        
        if(success){
            if(response.result.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:response.result viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"success_title", @"") message:NSLocalizedString(@"success_emailchanged", @"") viewController:self];
        }else{
            if(response.error.length > 0)
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:response.error viewController:self];
            else
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_failed_update_title", @"") message:NSLocalizedString(@"error_failed_connection", @"") viewController:self];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 3;
    else if(section == 1)
        return 1;
    else if(section ==2)
        return 2;
    else
        return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfigurationTableViewCell *cell;
    
    //Basic Information
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
            cell.descTextField.text = APIManager.sharedInstance.user.fullName;
        }else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"username" forIndexPath:indexPath];
            cell.descTextField.text = APIManager.sharedInstance.user.userName;
            cell.disableSpaces = true;
        }else if(indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"password" forIndexPath:indexPath];
            cell.descTextField.text = APIManager.sharedInstance.user.password;
        }
    }
    // User Bio
    else if(indexPath.section==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"userBioContent" forIndexPath:indexPath];
        cell.userBioTextView.text = APIManager.sharedInstance.user.userBio;
    }
    // Profile Pictures
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"changePicture" forIndexPath:indexPath];
        }else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"removePicture" forIndexPath:indexPath];
        }
    }
    
    // Other
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            cell = [tableView dequeueReusableCellWithIdentifier:@"terms" forIndexPath:indexPath];
        }else if(indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"privacy" forIndexPath:indexPath];
        }else if(indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"licenses" forIndexPath:indexPath];
        }else if(indexPath.row == 3){
            cell = [tableView dequeueReusableCellWithIdentifier:@"feedback" forIndexPath:indexPath];
        }else if(indexPath.row == 4){
            cell = [tableView dequeueReusableCellWithIdentifier:@"rate" forIndexPath:indexPath];
        }
//        else if(indexPath.row == 3){
//            cell = [tableView dequeueReusableCellWithIdentifier:@"offline" forIndexPath:indexPath];
//            [cell.offlineSwitch setOn:APIManager.sharedInstance.offlineMode animated:TRUE];
//        }
    }
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Basic Information
    if(indexPath.section == 0)
        return 37;
    // user bio
    else if(indexPath.section == 1)
        return 120;
    // Profile Pictures
    else if(indexPath.section == 2)
        return 46.5;
    
    // Other
    else if(indexPath.section == 3)
        return 46.5;
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Basic Information
    if(section == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicInformationHeader"];
        return cell;
    }
    //Basic Information
    if(section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userBioHeader"];
        return cell;
    }
    // Profile Pictures
    else if(section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profilePictureHeader"];
        return cell;
    }
    
    // Other
    else if(section == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherHeader"];
        return cell;
    }
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"index path: %lu", indexPath.row);
    
    //Basic Information
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }else if(indexPath.row == 1){
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }else if(indexPath.row == 2){
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }
    }
    //user Bio
    if(indexPath.section == 1){
        [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    }
    // Profile Pictures
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }else if(indexPath.row == 1){
            [self removeUserPicture];
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }
    }
    
    // Other
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }else if(indexPath.row == 1){
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }else if(indexPath.row == 2){
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }else if(indexPath.row == 3){
            [self showEmail];
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }else if(indexPath.row == 4){
            [self takeUserToLeaveReview];
            [self.tableView deselectRowAtIndexPath:indexPath animated:true];
        }
    }
}

-(void)takeUserToLeaveReview{
    
    NSLog(@"URL: %@",[NSString stringWithFormat:@"%@%d", iOSAppStoreURLFormat,APP_ID]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", iOSAppStoreURLFormat,APP_ID]]];
}

#pragma mark - Configurations Delegate

-(void)textFieldContentDidChange:(NSString *)content index:(NSIndexPath*)indexPath{
    //Basic Information
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self changeFullName:content];
        }else if(indexPath.row == 1){
            [self changeUsername:content];
        }else if(indexPath.row == 2){
            [self changePassword:content];
        }
    }
    //user Bio
    if(indexPath.section == 1){
        //[self changeFullName:content];
    }
    // Profile Pictures
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            
        }else if(indexPath.row == 1){
            
        }
    }
    
    // Other
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            
        }else if(indexPath.row == 1){
            
        }else if(indexPath.row == 2){
            
        }else if(indexPath.row == 3){
            
        }else if(indexPath.row == 4){
            
        }
    }
}

-(void)textViewContentDidChange:(NSString *)content index:(NSIndexPath*)indexPath{
    //Basic Information
    if(indexPath.section == 0){
        if(indexPath.row == 0){
//            [self changeFullName:content];
        }else if(indexPath.row == 1){
//            [self changeUsername:content];
        }else if(indexPath.row == 2){
//            [self changePassword:content];
        }
    }
    //user Bio
    if(indexPath.section == 1){
        [self changeUserBio:content];
    }
    // Profile Pictures
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            
        }else if(indexPath.row == 1){
            
        }
    }
    
    // Other
    else if(indexPath.section == 3){
        if(indexPath.row == 0){
            
        }else if(indexPath.row == 1){
            
        }else if(indexPath.row == 2){
            
        }else if(indexPath.row == 3){
            
        }else if(indexPath.row == 4){
            
        }
    }
}

//-(void)switchDidChange:(BOOL)switchValue index:(NSIndexPath*)indexPath{
//        
//    //Basic Information
//    if(indexPath.section == 0){
//        if(indexPath.row == 0){
//            
//            //push notifications
//            
//        }else if(indexPath.row == 1){
//            
//        }else if(indexPath.row == 2){
//        }
//    }
//    // Profile Pictures
//    else if(indexPath.section == 1){
//        if(indexPath.row == 0){
//            
//        }else if(indexPath.row == 1){
//            
//        }
//    }
//    
//    // Other
//    else if(indexPath.section == 2){
//        if(indexPath.row == 0){
//            
//        }else if(indexPath.row == 1){
//            
//        }else if(indexPath.row == 2){
//            
//        }else if(indexPath.row == 3){
//            
//        }else if(indexPath.row == 4){
//            APIManager.sharedInstance.offlineMode = switchValue;
//            [APIManager.sharedInstance saveDefaults];
//        }
//    }
//}
#pragma mark - CameraChoiceDelegate

-(void)cameraOptionSelected:(CameraOptions)option{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.sourceType = option == CameraOptionCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
    
    [self uploadUserPhotos:image];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - MFMailComposerViewController
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:{
            break;
        }
        case MFMailComposeResultSaved:{
            break;
        }
        case MFMailComposeResultSent:{
            break;
        }
        case MFMailComposeResultFailed:{
            break;
        }
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
