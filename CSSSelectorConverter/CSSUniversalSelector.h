//
//  CSSUniversalSelector.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSBaseSelector.h"

#define PUSH_CSS_UNIVERSAL() [self.assembly push:([CSSUniversalSelector selector])]

@interface CSSUniversalSelector : CSSBaseSelector

+(instancetype) selector;

@end
