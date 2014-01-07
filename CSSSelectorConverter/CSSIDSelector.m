//
//  CSSIDSelector.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSIDSelector.h"

@implementation CSSIDSelector

-(NSString*) description {
    return [NSString stringWithFormat:@"<IDSelector %@>", self.name];
}

-(NSString*) toXPath {
    return [NSString stringWithFormat:@"@id = '%@'", self.name];
}

@end
