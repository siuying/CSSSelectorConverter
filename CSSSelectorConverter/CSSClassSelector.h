//
//  CSSClassSelector.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSNamedSelector.h"

#define PUSH_CSS_CLASS(name) [self.assembly push:([CSSClassSelector selectorWithName:(name)])];

@interface CSSClassSelector : CSSNamedSelector

@end
