//
//  CSSTypeSelector.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSNamedSelector.h"

#define PUSH_CSS_TYPE(name) [self.assembly push:([CSSTypeSelector selectorWithName:(name)])]

@interface CSSTypeSelector : CSSNamedSelector <CPParseResult>

@end
