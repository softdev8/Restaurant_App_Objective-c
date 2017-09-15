//
//  ImageCropViewController.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 5/16/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "ImageCropViewController.h"
#import "DesignableImageView.h"
#import "UIImage+Cropping.h"

@interface ImageCropViewController () <UIScrollViewDelegate>{
    BOOL dragging;
    BOOL zooming;
    BOOL portraitImage;
    CGRect fullSizeImageFrame;
    CGPoint fullSizeImageOffset;
    CGSize fullSizeImageContentSize;
}

@property (weak, nonatomic) IBOutlet UIScrollView *cropScrollView;
//@property (strong, nonatomic) UIView *cropView;
@property (strong, nonatomic) UIImageView *cropImageView;
@property (weak, nonatomic) IBOutlet DesignableImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@end

@implementation ImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cropScrollView.delegate = self;
    self.cropScrollView.maximumZoomScale = 5;
    
    //portraitImage = self.image.size.height > self.image.size.width;
    
    self.cropImageView = [[UIImageView alloc] initWithImage:self.image];
    self.cropImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.cropImageView.layer.masksToBounds = YES;
    self.cropImageView.frame = self.cropScrollView.frame;
    [self.cropScrollView addSubview:self.cropImageView];
    
}

-(void)viewDidLayoutSubviews{
    fullSizeImageFrame = CGRectMake(0, 0, 0, 0);
    
    if(portraitImage){
        fullSizeImageFrame.size.height = self.maskImageView.frame.size.height;
        fullSizeImageFrame.size.width = ((self.cropImageView.image.size.width*self.maskImageView.frame.size.height)/self.cropImageView.image.size.height);
        fullSizeImageFrame.origin.y = self.cropScrollView.frame.size.height/2-fullSizeImageFrame.size.height/2;
        self.cropImageView.frame = fullSizeImageFrame;
        
        self.cropScrollView.minimumZoomScale = self.maskImageView.frame.size.width/fullSizeImageFrame.size.width;
    }else{
        self.cropImageView.frame = self.cropScrollView.frame;
        fullSizeImageFrame.size.height = ((self.cropImageView.image.size.height*self.maskImageView.frame.size.width)/self.cropImageView.image.size.width);
        fullSizeImageFrame.size.width = self.maskImageView.frame.size.width;
        fullSizeImageFrame.origin.y = self.cropScrollView.frame.size.height/2-fullSizeImageFrame.size.height/2;
        
        self.cropScrollView.minimumZoomScale = self.maskImageView.frame.size.height/fullSizeImageFrame.size.height;
    }
    
    self.cropScrollView.zoomScale = self.cropScrollView.minimumZoomScale;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

#pragma mark - Events

- (IBAction)chooseButtonPressed:(id)sender {
    self.maskImageView.hidden = true;
    UIImage *image = [UIImage imageWithView:self.view bounds:self.maskImageView.frame];
    self.maskImageView.hidden = false;
    
    [self.delegate finishedCroppingImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Scrollview delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.cropImageView;
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    zooming = true;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    zooming = false;
    [self fixScrollPosition:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dragging = false;
    [self fixScrollPosition:scrollView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    dragging = true;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(dragging || zooming)
    return;
    
    [self fixScrollPosition:scrollView];
}

-(void)fixScrollPosition:(UIScrollView*)scrollView{
    if(fullSizeImageOffset.x == 0 && fullSizeImageOffset.y == 0)
        fullSizeImageOffset = self.cropScrollView.contentOffset;
    if(fullSizeImageContentSize.width == 0 && fullSizeImageContentSize.height == 0)
        fullSizeImageContentSize = self.cropScrollView.contentSize;
    
    float growth = (scrollView.zoomScale/self.cropScrollView.minimumZoomScale)-1;
    
    if(portraitImage){
        float minXOffset = fullSizeImageOffset.x+(fullSizeImageOffset.x*growth)+((145*[[UIScreen mainScreen] bounds].size.width/375))*growth;
        float maxXOffset = [[UIScreen mainScreen] bounds].size.width;
        
        NSLog(@"contentoffset: %f-%f", scrollView.contentOffset.x, scrollView.contentOffset.y);
        NSLog(@"contentsize: %f-%f", scrollView.contentSize.width, scrollView.contentSize.height);
        NSLog(@"minmax: %f-%f", minXOffset, maxXOffset);
        NSLog(@"growth: %f", growth);
        
//        if(scrollView.contentOffset.x < minXOffset)
//            self.cropScrollView.contentOffset = CGPointMake(minXOffset, self.cropScrollView.contentOffset.y);
//        if(scrollView.contentOffset.x > maxXOffset)
//            self.cropScrollView.contentOffset = CGPointMake(maxXOffset, self.cropScrollView.contentOffset.y);
    }else{
        float minYOffset = fullSizeImageOffset.y+(fullSizeImageOffset.y*growth)+((145*[[UIScreen mainScreen] bounds].size.width/375))*growth;
        float maxYOffset = fullSizeImageOffset.y+(fullSizeImageOffset.y*growth)+((([[UIScreen mainScreen] bounds].size.height-145)*[[UIScreen mainScreen] bounds].size.width/375))*growth;
        
        if(scrollView.contentOffset.y < minYOffset)
            self.cropScrollView.contentOffset = CGPointMake(self.cropScrollView.contentOffset.x, minYOffset);
        else if(scrollView.contentOffset.y > maxYOffset)
            self.cropScrollView.contentOffset = CGPointMake(self.cropScrollView.contentOffset.x, maxYOffset);
    }
}

@end
