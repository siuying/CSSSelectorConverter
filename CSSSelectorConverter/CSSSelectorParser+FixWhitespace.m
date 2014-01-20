//
//  CSSSelectorParser+FixWhitespace.m
//  CSSSelectorConverter
//
//  Created by Francis Chong on 1/20/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CSSSelectorParser+FixWhitespace.h"

@implementation CSSSelectorParser (FixWhitespace)
    
- (void) matchS:(BOOL)discard {
    [self matchWhitespace:discard];
}

@end
