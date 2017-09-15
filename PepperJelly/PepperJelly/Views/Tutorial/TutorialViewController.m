//
//  TutorialViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 3/30/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "TutorialViewController.h"
#import "Tutorial1CollectionViewCell.h"
#import "Tutorial2CollectionViewCell.h"
#import "DesignableView.h"
#import "DesignableButton.h"
#import "UIColor+PepperJelly.h"

@interface TutorialViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet DesignableView *controlBall1View;
@property (weak, nonatomic) IBOutlet DesignableView *controlBall2View;
@property (weak, nonatomic) IBOutlet DesignableButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageControl.numberOfPages = 2;
    [self updateBalls];
}

#pragma mark - CollectionView data source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pageControl.numberOfPages;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        Tutorial1CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tutorial1" forIndexPath:indexPath];
        return cell;
    }else{
        Tutorial2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tutorial2" forIndexPath:indexPath];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [((Tutorial1CollectionViewCell*) cell) prepareForAnimation];
        [((Tutorial1CollectionViewCell*) cell) animateIn];
    }else{
        [((Tutorial2CollectionViewCell*) cell) prepareForAnimation];
        [((Tutorial2CollectionViewCell*) cell) animateIn];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

#pragma mark - Scrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
    
    [self updateBalls];
}

#pragma mark - Tutorial Delegate

- (IBAction)nextButtonPressed:(id)sender {
    if(self.pageControl.currentPage == self.pageControl.numberOfPages - 1){
        [self skipButtonPressed:sender];
    }else{
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.collectionView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.collectionView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (IBAction)skipButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"feedSegue" sender:self];
}

-(void)updateBalls{
    if(self.pageControl.currentPage == 0){
        self.controlBall1View.borderColor = [UIColor greyishBrownColor];
        self.controlBall2View.borderColor = [UIColor mediumGreyColor];
        [self.nextButton setTitle:NSLocalizedString(@"tutorial_next", @"") forState:UIControlStateNormal];
    }else{
        self.controlBall1View.borderColor = [UIColor mediumGreyColor];
        self.controlBall2View.borderColor = [UIColor greyishBrownColor];
        [self.nextButton setTitle:NSLocalizedString(@"tutorial_ok", @"") forState:UIControlStateNormal];
    }
}

@end
