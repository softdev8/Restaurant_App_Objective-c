//
//  ImageCollectionViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/25/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ImageCollectionTableViewCell.h"
#import <Photos/Photos.h>

@interface ImageCollectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionFetchResults;
@property (nonatomic, strong) NSArray *sectionLocalizedTitles;

@end

@implementation ImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"libraries", @"");
    
    [self fetchAlbums];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableView.hidden = true;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self animateIn];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Events

- (IBAction)closeButtonPressed:(id)sender {
    [self animateOut];
}

#pragma mark - Animations

- (void)animateIn{
    self.tableView.hidden = false;
    self.tableView.alpha = 0;
    self.tableView.frame = CGRectMake(0, -self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height);
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tableView.alpha = 1;
        self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)animateOut{
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.alpha = 0;
        self.tableView.frame = CGRectMake(0, -self.tableView.frame.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height);
    } completion:^(BOOL finished) {
        self.tableView.hidden = true;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if(indexPath){
            if (indexPath.section == 0)
               [self.delegate collectionSelected:nil];
            else{
                PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
                PHCollection *collection = fetchResult[indexPath.row];
                
                if ([collection isKindOfClass:[PHAssetCollection class]]) {
                    [self.delegate collectionSelected:(PHAssetCollection*)collection];
                }else{
                    [self.delegate collectionSelected:nil];
                }
            }
        }
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
    }];
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionFetchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        numberOfRows = 1;
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[section];
        numberOfRows = fetchResult.count;
    }
    
    return numberOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageCollectionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"noImage" forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = NSLocalizedString(@"all_photos", @"");
    } else {
        PHFetchResult *fetchResult = self.sectionFetchResults[indexPath.section];
        PHCollection *collection = fetchResult[indexPath.row];
        cell.titleLabel.text = collection.localizedTitle;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self animateOut];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getCellSize];
}

-(float)getCellSize{
    return 50;
}

#pragma mark - Photos

-(void)fetchAlbums{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    // Store the PHFetchResult objects and localized titles for each section.
    self.sectionFetchResults = @[allPhotos, topLevelUserCollections, smartAlbums];
    self.sectionLocalizedTitles = @[@"", NSLocalizedString(@"albums", @""), NSLocalizedString(@"smart_albums", @"")];
    
    [self.tableView reloadData];
    
//    //make tableview size to fit content
//    float height = ((1+smartAlbums.count+topLevelUserCollections.count) * [self getCellSize])+64;
//    if(height < self.view.frame.size.height){
//        self.tableView.translatesAutoresizingMaskIntoConstraints = true;
//        self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, height);
//    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionLocalizedTitles[section];
}

@end
