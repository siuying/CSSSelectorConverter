//
//  CSSChildSelector.m
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSChildSelector.h"

@implementation CSSChildSelector

-(NSString*) description {
    return @"<CSSChildSelector>";
}

-(NSString*) toXPath {
    return @"/";
}

@end
