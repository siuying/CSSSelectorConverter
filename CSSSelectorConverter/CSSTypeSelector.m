//
//  CSSTypeSelector.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSTypeSelector.h"

@implementation CSSTypeSelector

-(NSString*) description {
    return [NSString stringWithFormat:@"<TypeSelector %@>", self.name];
}

-(NSString*) toXPath {
    return [NSString stringWithFormat:@"%@", self.name];
}

@end
