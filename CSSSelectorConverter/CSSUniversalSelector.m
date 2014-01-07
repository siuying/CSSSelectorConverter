//
//  CSSUniversalSelector.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSUniversalSelector.h"

@implementation CSSUniversalSelector

+(instancetype) selector {
    return [[self alloc] init];
}

-(NSString*) description {
    return @"<UniversalSelector>";
}

-(NSString*) toXPath {
    return @"//*";
}

@end
