//
//  RestaurantMapTableViewCell.m
//  PepperJelly
//
//  Created by Peter Simpson on 9/23/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "RestaurantMapTableViewCell.h"

@implementation RestaurantMapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _mapImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_mapImage];
    
}


@end
