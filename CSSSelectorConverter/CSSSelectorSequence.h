//
//  CSSSelectorSequence.h
//  CSSSelectorConverter
//
//  Created by Francis Chong on 7/1/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSBaseSelector.h"
#import <ParseKit/ParseKit.h>

#define PUSH_SELECTOR_SEQUENCE() [CSSSelectorSequence selectorWithAssembly:self.assembly];

@interface CSSSelectorSequence : CSSBaseSelector

@property (nonatomic, strong) CSSBaseSelector* universalOrTypeSelector;

@property (nonatomic, strong) NSMutableArray* otherSelectors;

-(void) addSelector:(CSSBaseSelector*)selector;

+(instancetype) selectorWithAssembly:(PKAssembly*)assembly;

@end
