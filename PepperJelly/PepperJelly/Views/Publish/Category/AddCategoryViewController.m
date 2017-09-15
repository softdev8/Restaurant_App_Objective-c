//
//  CategoryViewController.m
//  PepperJelly
//
//  Created by Sean McCue on 4/22/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "FilterTableViewCell.h"
#import "DesignableTextField.h"
#import "APIManager.h"
#import "Category.h"
#import "DataAccess.h"

@interface AddCategoryViewController () <UITextFieldDelegate>

- (IBAction)cancelBtnTapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet DesignableTextField *searchCategoriesTextField;
@property (nonatomic, strong) NSMutableDictionary *dataArray;
@property (nonatomic, strong) NSMutableArray *filteredDataArray;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSArray *dataTitles;
@property (nonatomic, assign) BOOL searching;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation AddCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.selectedCategoriesArray)
        self.selectedCategoriesArray = [[NSMutableArray alloc] init];
    
    self.tableView.sectionIndexBackgroundColor = self.tableView.backgroundColor;
    
    [self getSavedList];
    [self getCategoriesLIst];
    [self configureNavBar];
}

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

-(void)configureNavBar{
    self.navigationItem.hidesBackButton = true;
}

#pragma mark - Navigation
-(void)unwindSegue{
    [self performSegueWithIdentifier:@"unwindToPublish" sender:nil];
}

#pragma mark - Events
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
            if(![self.filteredDataArray containsObject:category.name])
                [self.filteredDataArray addObject:category.name];
        }
        
        [self.tableView reloadData];
    }
}

-(void)getSavedList{
    self.categories = [[NSMutableArray alloc] init];
    NSArray *results = [Category getAll];
    for (Category *category in results) {
        if(![self.categories containsObject:category.name])
            [self.categories addObject:category.name];
    }
    if(self.categories.count > 0){
        [self configureCategoryData];
        [self.tableView reloadData];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    [self unwindSegue];
}

- (IBAction)cancelBtnTapped:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    if(self.searching){
        return @[];
    }else{
        return self.dataTitles;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.searching){
      return  @"";
    }else{
        return [self.dataTitles objectAtIndex:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    if(self.searching){
        cell.titleLabel.text = [self.filteredDataArray objectAtIndex:indexPath.row];
    }else{
        NSString *sectionTitle = [self.dataTitles objectAtIndex:indexPath.section];
        NSArray *sectionData = [self.dataArray objectForKey:sectionTitle];
        NSString *entry = [sectionData objectAtIndex:indexPath.row];
        cell.titleLabel.text = entry;
    }
    cell.checkImageView.hidden = ![self.selectedCategoriesArray containsObject:cell.titleLabel.text];
    
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
    if([self.selectedCategoriesArray containsObject:categoryName])
        [self.selectedCategoriesArray removeObject:categoryName];
    else
        [self.selectedCategoriesArray addObject:categoryName];
    
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
}

#pragma  mark - API
-(void)getCategoriesLIst{
    [[APIManager sharedInstance] getCategoryListWithCompletion:^(BOOL success, APIResponse *response) {
        if(success){
            if([response.results respondsToSelector:@selector(count)]){
                [self.categories removeAllObjects];
                for (Category *category in response.results) {
                    if(![self.categories containsObject:category.name])
                        [self.categories addObject:category.name];
                }
                [self configureCategoryData];
            }else{
                NSLog(@"failed to get categories list");
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_get_categories_list", @"") viewController:self];
            }
        }else{
            if(![self.categories respondsToSelector:@selector(count)]){
                NSLog(@"failed to get categories list");
                [APIManager showAlertWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"error_failed_get_categories_list", @"") viewController:self];
            }
        }
    }];
}

@end
