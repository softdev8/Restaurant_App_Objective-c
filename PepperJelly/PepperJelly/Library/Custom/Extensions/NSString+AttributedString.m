//
//  NSObject+NSString_AttributedString.m
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/22/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import "NSString+AttributedString.h"

@implementation NSString (AttributedString)

+(NSAttributedString *)attributedStringWith:(NSArray*)attributedTexts{
    NSString *completeString = @"";
    for(AttributedText *at in attributedTexts){
        if(at.text)
            completeString = [completeString stringByAppendingString:at.text];
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:completeString];
    
    int sizeSoFar = 0;
    for(AttributedText *at in attributedTexts){
        [attributedText setAttributes:at.attributes range:NSMakeRange(sizeSoFar, at.text.length)];
        sizeSoFar += at.text.length;
    }
    
    return attributedText;
}

@end

@implementation AttributedText

-(id)initWithText:(NSString*)text andAttribute:(NSDictionary*)attribute{
    self = [super init];
    if(self) {
        self.text = text;
        self.attributes = attribute;
    }
    return self;
}

@end
