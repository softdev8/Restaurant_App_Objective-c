//
//  PJActivityItemProvider.m
//  PepperJelly
//
//  Created by Sean McCue on 4/28/16.
//  Copyright © 2016 DogTownMedia. All rights reserved.
//

#import "PJActivityItemProvider.h"

@implementation PJActivityItemProvider

-(id)initWithPlaceholderItem:(id)placeholderItem{
    return [super initWithPlaceholderItem:placeholderItem];
}

-(id)item{
    return @"";
}

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType{
    if([activityType isEqualToString:UIActivityTypePostToTwitter]){
        NSLog(@"post to twitter");
        return self.twitterText;
    }
    else{
        return self.generalText;
    }
}

-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController{
    return @"";
}
@end
