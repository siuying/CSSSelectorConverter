//
//  CSSChildSelector.h
//  CSSSelectorConverter
//
//  Created by Chong Francis on 14年1月8日.
//  Copyright (c) 2014年 Ignition Soft. All rights reserved.
//

#import "CSSBaseSelector.h"

#define PUSH_CHILD_SELECTOR() [self.assembly push:([CSSChildSelector selector])];

@interface CSSChildSelector : CSSBaseSelector

@end
