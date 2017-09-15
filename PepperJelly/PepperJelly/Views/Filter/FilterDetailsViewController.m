//
//  FilterDetailsViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 06/07/2016.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "FilterDetailsViewController.h"
#import "DesignableTextField.h"
#import "FilterTableViewCell.h"
#import "DesignableButton.h"
#import "Constants.h"
#import "LocationsViewController.h"
#import "APIManager.h"
#import "Category.h"
#import "UIView+Loading.h"
#import "User.h"
#import "UserCategory.h"
#import "SearchManager.h"
#import "Search.h"
#import "DataAccess.h"

@interface FilterDetailsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    CGPoint searchImageStartingPoint;
    BOOL shouldShowTitles;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet DesignableTextField *searchTextView;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dataArray;
@property (nonatomic, strong) NSMutableArray *filteredDataArray;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSArray *dataTitles;
@property (nonatomic, assign) BOOL searching;

@end

@implementation FilterDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"select", @""), self.categoryItem.name];
    
    self.tableView.sectionIndexBackgroundColor = self.tableView.backgroundColor;
    
    shouldShowTitles = self.categoryItem.subcategoriesToShow.count >= 25;
    
    [self getSavedList];
}

-(void)viewDidLayoutSubviews{
    searchImageStartingPoint = self.searchImageView.center;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - Events

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate handleCategoriesSelected:self.categoryItem.subcategories];
    [self dismissViewControllerAnimated:YES completion:nil];
    // [self performSegueWithIdentifier:@"unwindToFilter" sender:self];
}

#pragma mark - Data

-(void)configureCategoryData{
    self.searching = false;
    self.dataArray = [NSMutableDictionary new];
    
    for (NSString *str in self.categories) {
        NSString *firstLetter = [str substringToIndex:1];
        NSMutableArray *filteredArray = [NSMutableArray new];
        
        for(NSString *str in self.categories){
            if([[str substringToIndex:1] isEqualToString:firstLetter]){
                [filteredArray addObject:str];
            }
        }
        
        [self.dataArray setObject:filteredArray forKey:[firstLetter uppercaseString]];
    }
    self.dataTitles = [[self.dataArray allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.tableView reloadData];
}

-(void)searchDataWithStr:(NSString *)searchTerm{
    NSLog(@"%@", searchTerm);
    
    self.searching = true;
    self.filteredDataArray = [NSMutableArray new];
    NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
    NSString *searchAttribute = @"name";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchTerm];
    NSError *error = nil;
    NSFetchRequest *fecthRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    [fecthRequest setPredicate:predicate];
    NSArray *searchResults = [NSArray new];
    searchResults = [[DataAccess.sharedInstance managedObjectContext] executeFetchRequest:fecthRequest error:&error];
    
    if([searchResults respondsToSelector:@selector(count)]){
        for (Category *category in searchResults) {
            [self.filteredDataArray addObject:category.name];
        }
        
        [self.tableView reloadData];
    }
}

-(void)getSavedList{
    self.categories = [[NSMutableArray alloc] initWithArray:self.categoryItem.subcategoriesToShow];
    [self configureCategoryData];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.searching){
        return 1;
    }else{
        return [self.dataTitles count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searching){
        return self.filteredDataArray.count;
    }else{
        NSString *sectionTitle = [self.dataTitles objectAtIndex:section];
        NSArray *sectionData = [self.dataArray objectForKey:sectionTitle];
        return [sectionData count];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(self.searching || !shouldShowTitles){
        return @[];
    }else{
        return self.dataTitles;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.searching || !shouldShowTitles){
        return  @"";
    }else{
        return [self.dataTitles objectAtIndex:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filter" forIndexPath:indexPath];
    
    if(self.searching){
        cell.titleLabel.text = [self.filteredDataArray objectAtIndex:indexPath.row];
    }else{
        NSString *sectionTitle = [self.dataTitles objectAtIndex:indexPath.section];
        NSArray *sectionData = [self.dataArray objectForKey:sectionTitle];
        NSString *entry = [sectionData objectAtIndex:indexPath.row];
        cell.titleLabel.text = entry;
    }
    cell.checkImageView.hidden = ![self.categoryItem.subcategories containsObject:cell.titleLabel.text];
    
    return cell;
}


#pragma mark - TablveViewDelegate Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *categoryName = @"";
    if(self.searching){
        categoryName = [self.filteredDataArray objectAtIndex:indexPath.row];
        //self.selectedCategory = [self.filteredDataArray objectAtIndex:indexPath.row];
    }else{
        NSString *sectionTitle = [self.dataTitles objectAtIndex:indexPath.section];
        NSArray *sectionData = [self.dataArray objectForKey:sectionTitle];
        //self.selectedCategory = [sectionData objectAtIndex:indexPath.row];
        categoryName = [sectionData objectAtIndex:indexPath.row];
    }
    //[self unwindSegue];
    if([self.categoryItem.subcategories containsObject:categoryName])
        [self.categoryItem.subcategories removeObject:categoryName];
    else
        [self.categoryItem.subcategories addObject:categoryName];
    
    [tableView reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - UITextfieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    NSString *searchTerm = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(searchTerm.length == 0){
        self.searching = false;
        [self.tableView reloadData];
        return true;
    }
    
    NSLog(@"new string: %@", searchTerm);
    
    [self searchDataWithStr:searchTerm];
    
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.searching = false;
    [self.tableView reloadData];
    
    if(textField.text.length == 0) {
        [UIView animateWithDuration:0.2f animations:^{
            self.searchImageView.center = searchImageStartingPoint;
        }];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2f animations:^{
        self.searchImageView.center = CGPointMake(textField.frame.origin.x+20, self.searchImageView.center.y);
    }];
}

@end
