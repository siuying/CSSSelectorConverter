//
//  CSSClassSelector.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSClassSelector.h"

@implementation CSSClassSelector

-(NSString*) description {
    return [NSString stringWithFormat:@"<ClassSelector %@>", self.name];
}

-(NSString*) toXPath {
    return [NSString stringWithFormat:@"[contains(concat(' ', normalize-space(@class), ' '), ' %@ ')]", self.name];
}

@end
