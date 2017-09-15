//
//  NSObject+NSString_AttributedString.h
//  PepperJelly
//
//  Created by Evandro Harrison Hoffmann on 2/22/16.
//  Copyright © 2016 Evandro Harrison Hoffmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedString)

+(NSAttributedString*)attributedStringWith:(NSArray*)attributedTexts;

@end

@interface AttributedText : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDictionary *attributes;

-(id)initWithText:(NSString*)text andAttribute:(NSDictionary*)attribute;

@end
