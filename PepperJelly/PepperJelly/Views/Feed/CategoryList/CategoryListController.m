//
//  CategoryListController.m
//  PepperJelly
//
//  Created by Sean McCue on 6/6/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "CategoryListController.h"
#import "CategoryListTablViewCell.h"
#import "CDHelper.h"
#import "Category.h"

@interface CategoryListController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *backgroundView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *categoryList;
@property (nonatomic, strong) NSArray *categoryData;
@end

@implementation CategoryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
    [self syncronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}

-(void)syncronize{
    self.categoryList = [NSMutableArray new];
    self.categoryData = [CDHelper sortArray:[self.restaurant.categories allObjects] by:@"order" ascending:YES];
    for(Category *category in self.categoryData){
        [self.categoryList addObject:category.name];
    }

    NSLog(@"categories: %@", self.categoryList);
}

-(void)configureTableView{
    [self.tableView setSeparatorColor:[UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0f]];
}

#pragma mark - Events
- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoriesHeader"];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10000);
        return cell;
    }else{
        CategoryListTablViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category" forIndexPath:indexPath];
        cell.categoryLabel.text = [self.categoryList objectAtIndex:indexPath.row-1];
        return cell;
    }
    
    return [UITableViewCell new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryList.count+1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 115;
    }else{
        return 45;
    }
}


@end
