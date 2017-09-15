//
//  TermsViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/19/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "TermsViewController.h"
#import "UIView+Loading.h"

@interface TermsViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.name;
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.file ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - Events

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Web View Delegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view startLoading];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.view stopLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

@end
