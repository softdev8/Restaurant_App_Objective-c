//
//  ImageCollectionTableViewCell.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 4/25/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
