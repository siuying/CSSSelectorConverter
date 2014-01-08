//
//  CSSUniversalSelector.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSTypeSelector.h"

#define PUSH_CSS_UNIVERSAL() [self.assembly push:([CSSUniversalSelector selector])]

@interface CSSUniversalSelector : CSSTypeSelector

@end
